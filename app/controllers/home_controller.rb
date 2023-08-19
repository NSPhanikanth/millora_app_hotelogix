class HomeController < ApplicationController

    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token

    def index
        @properties = {}
        Hotel.all.each{|hotel_details|
            location = hotel_details["location"]
            @properties[location] = [] if @properties[location].nil?
            @properties[location].append({'name' => hotel_details["name"], 'id' => hotel_details["id"]})
        }
        @room_types = Room.pluck(:room_type).uniq
    end

    def submit
        checkin = params["checkin"].strip
        checkout = params["checkout"].strip
        start_date = Date.parse(checkin)
        end_date = Date.parse(checkout)
        hotel_id = params["hotel_id"]
        # room_type_id = "aE1LeTFReTdqMzg9"

        @room_types = []
        room_id_type_mappings = {}
        @available_status = {}
        total_occupancy = {}
        split_allowed = {}
        Room.all.each{|room|
            @room_types << room["room_type"]
            room_id_type_mappings[room["hlx_room_id"]] = room["room_type"]
            if total_occupancy[room["room_type"]].nil?
                total_occupancy[room["room_type"]] = room["occupancy"]
            else
                total_occupancy[room["room_type"]] += room["occupancy"]
            end
            split_allowed[room["hlx_room_id"]] = room["is_split_allowed"]
        }
        @room_types.uniq!
        @room_types.each do |room_type|
            @available_status[room_type] = {}
            (start_date..end_date).each{|date_|
                @available_status[room_type][date_.strftime("%F")] = total_occupancy[room_type]
            }
        end

        # splitted_date = params["checkin"].split(",")
        # date, month = splitted_date[1].strip.split(" ")
        # year = splitted_date[2].strip
        # month = MONTHS[month]
        # checkin = "#{year}-#{month}-#{date}"

        # splitted_date = params["checkout"].split(",")
        # date, month = splitted_date[1].strip.split(" ")
        # year = splitted_date[2].strip
        # month = MONTHS[month]
        # checkout = "#{year}-#{month}-#{date}"


        hotel = Hotel.find_by(id: hotel_id)

        script_file = Rails.root.join("lib", "scripts", "get_bookings_data.js").to_s

        current_time = Time.now.to_i.to_s
        if Rails.env.development?
            output_path = Rails.root.join("public", "bookings_response", current_time + ".json").to_s
        else
            output_path = File.join(Rails.root.to_s.split("releases")[0], "shared", "public", "bookings_response", current_time + ".json").to_s
        end
        cmd = "node #{script_file} #{hotel.hlx_access_key} #{hotel.hlx_access_secret} #{checkin} #{checkout} #{output_path}"
        puts "Command Executing is: #{cmd}"
        cmd_resp = `#{cmd}`
        puts "Command response is: #{cmd_resp}"
        booking_details = BookingsHelper.parse_response(output_path)
        # booking_details.each do |booking_detail|
        # end
        puts "booking_details : #{booking_details}"
        # @available_status = {"Single"=>{"2023-08-14"=>8, "2023-08-15"=>8, "2023-08-16"=>3, "2023-08-17"=>2, "2023-08-18"=>5, "2023-08-19"=>2, "2023-08-20"=>5}, "Double"=>{"2023-08-14"=>9, "2023-08-15"=>8, "2023-08-16"=>3, "2023-08-17"=>3, "2023-08-18"=>9, "2023-08-19"=>5, "2023-08-20"=>7}, "Twin"=>{"2023-08-14"=>9, "2023-08-15"=>8, "2023-08-16"=>4, "2023-08-17"=>4, "2023-08-18"=>0, "2023-08-19"=>6, "2023-08-20"=>8}}
        @dates = start_date..end_date
        respond_to do |format|
            format.js
        end
        # render json: {status: 'success', message: 'Success', resp: resp}
    end
end