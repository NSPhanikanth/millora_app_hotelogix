module BookingsHelper
    def self.parse_response(bookings = [])
        # x = File.open("/Users/phani/phani_test_this/split_booking_details.json").read
        guest_stay_details = []
        bookings.each{|booking|
            room_stays = {}
            booking["roomStays"].each{|room_selected|
                room_stays[room_selected["date"]] = {"roomId" => room_selected["roomId"], "roomTypeId" => room_selected["roomTypeId"]}
            }
            booking["guestStays"].each{|guest_details|
                temp = {}
                temp["booking_id"] = booking["id"]
                temp["salutation"] = guest_details["guestDetails"]["salutation"]
                temp["first_name"] = guest_details["guestDetails"]["fName"]
                temp["last_name"] = guest_details["guestDetails"]["lName"]
                temp["email"] = guest_details["guestDetails"]["email"]
                temp["phone_no"] = guest_details["guestDetails"]["phoneNo"]
                temp["mobile_no"] = guest_details["guestDetails"]["mobileNo"]
                temp["gender"] = guest_details["guestDetails"]["gender"]
                temp["employee_id"] = guest_details["guestDetails"]["customField"]["Employee ID"]
                ((guest_details["checkInDate"].to_date)..(guest_details["checkOutDate"].to_date - 1.day)).each{|date_|
                    date_ = date_.strftime("%F")
                    room_details = {}
                    room_details["roomId"] = room_stays[date_]["roomId"]
                    room_details["roomTypeId"] = room_stays[date_]["roomTypeId"]
                    room_details["date"] = date_
                    guest_stay_details.append(temp.merge(room_details))
                }
            }
        }
        return guest_stay_details
    end

    def self.fetch_response(hotel_id, checkin, checkout, count = 0)
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
        return [] if response.empty?
        status_code = response["hotelogix"]["response"]["status"]["code"] rescue 5000
        if status_code.to_i == 1900
            is_success = BookingsHelper.fetch_api_keys(hotel_id)
            if is_success and count == 0
                BookingsHelper.fetch_response(hotel_id, checkin, checkout, 1)
            else
                return []
            end
        elsif status_code.to_i == 5000
            return []
        else
            bookings = response["hotelogix"]["response"]["bookings"] rescue []
            return bookings
        end

    end

    def self.fetch_api_keys(hotel_id)
        hotel = Hotel.find_by(id: hotel_id)
        script_file = Rails.root.join("lib", "scripts", "wsauth_login.js").to_s
        current_time = Time.now.to_i.to_s
        if Rails.env.development?
            output_path = Rails.root.join("public", "bookings_response", current_time + ".json").to_s
        else
            output_path = File.join(Rails.root.to_s.split("releases")[0], "shared", "public", "bookings_response", current_time + ".json").to_s
        end
        cmd = "node #{script_file} false '#{hotel.hlx_consumer_key}' '#{hotel.hlx_consumer_secret}' '#{hotel.hlx_hotel_id}' '#{hotel.hlx_counter_id}' '#{hotel.hlx_counter_email}' '#{output_path}'"
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
end
