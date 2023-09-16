module BookingsHelper
    def self.parse_response(hotel_id, start_date, end_date, bookings = [])
        # x = File.open("/Users/phani/phani_test_this/split_booking_details.json").read

        room_id_room_mappings = {}

        room_type_details = {}
        hlx_room_type_mappings = {}
        hlx_hotel_id_room_type_mappings = {}
        RoomType.includes(:rooms).all.each do |room_type|
            rooms = room_type.rooms.select{|x| x.hotel_id == hotel_id}
            room_type_details[room_type.name] =  room_type.attributes.merge({"total_rooms" => rooms.size})
            hlx_room_type_mappings[room_type.hlx_room_type_id] = room_type.name
            rooms.each do |room_|
                hlx_hotel_id_room_type_mappings[room_.hlx_room_id] = room_type.name
            end
        end

        hotel_status = {}
        room_type_details.keys.each do |room_type|
            hotel_status[room_type] = {}
            (start_date..end_date).each do |date_|
                room_count = room_type_details[room_type]["total_rooms"]
                hotel_status[room_type][date_.strftime("%F")] = {"total_rooms" => room_count, "available_rooms" => room_count}
            end
        end

        bookings.each do |booking|
            room_stays = {}
            booking["roomStays"].each do |room_selected|
                room_id = room_selected["roomId"]
                room_type_id = room_selected["roomTypeId"]
                room_type_name = room_selected["roomTypeName"]
                room_date = room_selected["date"]
                mappings = {"Queen" => "Single", "Queen Size" => "Single", "Executive Room" => "Single", "Deluxe Room" => "Single", "Twin Room" => "Twin", "Queen Bed" => "Single", "Twin Bed" => "Twin", "Standard Queen"=> "Single", "Standard Queen."=> "Single", "Superior Queen"=> "Single"}
                room_type = hlx_hotel_id_room_type_mappings[room_id] || hlx_room_type_mappings[room_type_id] || mappings[room_type_name]
                # puts "room_type: #{room_type} - room_date: #{room_date} - #{(start_date..end_date).exclude?(room_date)}"
                next if room_type.nil? or (start_date..end_date).exclude?(room_date.to_date)
                # puts "Before Update : #{hotel_status[room_type][room_date]}"
                split_allowed = room_type_details[room_type]["is_split_allowed"] rescue false
                max_occupancy = room_type_details[room_type]["max_occupancy"] rescue 2
                room_stays[room_date] = {"split_allowed" => split_allowed, "max_occupancy" => max_occupancy, "room_type" => room_type}
                unless split_allowed
                    hotel_status[room_type][room_date]["available_rooms"] -= 1
                end
                # puts "After Update : #{hotel_status[room_type][room_date]}"
            end
            booking["guestStays"].each do |guest_details|
                ((guest_details["checkInDate"].to_date)..(guest_details["checkOutDate"].to_date - 1.day)).each do |date_|
                    next if (start_date..end_date).exclude?(date_)
                    date_ = date_.strftime("%F")
                    room_details = room_stays[date_] rescue nil
                    next if room_details.nil? or room_details["split_allowed"] == false
                    max_occupancy = room_details["max_occupancy"].to_i rescue 2
                    room_type = room_details["room_type"]
                    hotel_status[room_type][date_]["available_rooms"] -= (1.to_f/max_occupancy)
                end
            end
            # puts "hotel_status: #{hotel_status}"
        end
        return hotel_status
    end

    def self.fetch_response(hotel_id, checkin, checkout, count = 0)
        # TODO: Handle multiple page response
        hotel = Hotel.find_by(id: hotel_id)
        script_file = Rails.root.join("lib", "scripts", "get_bookings_data.js").to_s

        current_time = Time.now.to_i.to_s
        if Rails.env.development?
            output_path = Rails.root.join("public", "bookings_response", current_time + ".json").to_s
        else
            output_path = File.join(Rails.root.to_s.split("releases")[0], "shared", "public", "bookings_response", current_time + ".json").to_s
        end
        cmd = "node #{script_file} '#{hotel.hlx_access_key}' '#{hotel.hlx_access_secret}' '#{checkin}' '#{checkout}' '#{output_path}'"
        puts "Command Executing is: #{cmd}"
        cmd_resp = `#{cmd}`
        begin
            json_response = File.open(output_path).read
        rescue => e
            json_response = "{}"
        end
        response = JSON.parse(json_response) rescue {}
        return nil if response.empty?
        status_code = response["hotelogix"]["response"]["status"]["code"] rescue 5000
        if status_code.to_i == 1900
            is_success = BookingsHelper.fetch_api_keys(hotel_id)
            if is_success and count == 0
                BookingsHelper.fetch_response(hotel_id, checkin, checkout, 1)
            else
                return nil
            end
        elsif status_code.to_i == 5000
            return nil
        else
            bookings = response["hotelogix"]["response"]["bookings"] rescue []
            return bookings
        end

    end

    def self.fetch_api_keys(hotel_id, wsauth_required = false)
        hotel = Hotel.find_by(id: hotel_id)
        script_file = Rails.root.join("lib", "scripts", "wsauth_login.js").to_s
        current_time = Time.now.to_i.to_s
        if Rails.env.development?
            output_path = Rails.root.join("public", "bookings_response", current_time + ".json").to_s
        else
            output_path = File.join(Rails.root.to_s.split("releases")[0], "shared", "public", "bookings_response", current_time + ".json").to_s
        end
        cmd = "node #{script_file} #{wsauth_required} '#{hotel.hlx_consumer_key}' '#{hotel.hlx_consumer_secret}' '#{hotel.hlx_hotel_id}' '#{hotel.hlx_counter_id}' '#{hotel.hlx_counter_email}' '#{hotel.hlx_counter_pwd}' '#{output_path}'"
        puts "Command Executing is: #{cmd}"
        cmd_resp = `#{cmd}`
        begin
            json_response = File.open(output_path).read
        rescue => e
            json_response = "{}"
        end
        response = JSON.parse(json_response) rescue {}
        return false if response.empty?
        status_code = response["hotelogix"]["response"]["status"]["code"] rescue 5000
        return false if status_code.to_i != 0
        begin
            access_key = response['hotelogix']['response']['accesskey']
            access_secret = response['hotelogix']['response']['accesssecret']
        rescue
            return false
        end
        if access_secret.present? and access_key.present?
            hotel.update(hlx_access_key: access_key, hlx_access_secret: access_secret)
        else
            return false
        end
    end

    def self.combine_data(all_hotel_status)
        combined_data = {}
        all_hotel_status.each do |hotel_name, hotel_status|
            hotel_status.each do |room_type, details|
                combined_data[room_type] = {} if combined_data[room_type].nil?
                details.each do |date_, data|
                    combined_data[room_type][date_] = {"total_rooms" => 0, "available_rooms" => 0} if combined_data[room_type][date_].nil?
                    combined_data[room_type][date_]["total_rooms"] += data["total_rooms"]
                    combined_data[room_type][date_]["available_rooms"] += data["available_rooms"]
                end
            end
        end
        return combined_data
    end
end
