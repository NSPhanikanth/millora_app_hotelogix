def store_room_info(hotels, mappings, store_data = false)
    hotels.each do |hotel|
        puts "hotel id: #{hotel.id}"
        BookingsHelper.fetch_api_keys(hotel.id, true)
        hotel.reload
        if Rails.env.development?
            resp = `node /Users/phani/phani_test_this/get_house_status.js '#{hotel.hlx_access_key}' '#{hotel.hlx_access_secret}'`
        else
            resp = `node /home/millora/node_scripts/get_house_status.js '#{hotel.hlx_access_key}' '#{hotel.hlx_access_secret}'`
        end
        puts "resp received: #{resp}"
        resp = JSON.parse(resp.gsub("'", ""))
        resp["hotelogix"]["response"]["days"][0]["roomTypes"].each do |room_type|
            name_ = room_type["name"]
            puts "------------#{name_}"
            if store_data
                mapped_name = mappings[name_]
                room_type_obj = RoomType.create_with(max_occupancy: room_type["maxOccupancy"]).find_or_create_by(client_id: hotel.client_id, name: mapped_name || name_)
                # binding.pry
                room_type["rooms"].each do |room|
                    room = Room.create_with(room_name: room["name"], hlx_room_name: room["name"], is_active: true, room_type_id: room_type_obj.id, hlx_room_type_id: room_type["id"], hlx_room_type_name: room_type["name"]).find_or_create_by(hotel_id: hotel.id, hlx_room_id: room["id"])
                    if room.errors.present?
                        puts "*" * 50
                        puts room.errors.inspect
                        puts "*" * 50
                    end
                end
            end
        end
    end
end

client = Client.create_with(display_name: "Caratlane", logo: "caratlane.png", logo_2x: "caratlane_2x.png", access_key: "D1pOQgmP50Ql99J5").find_or_create_by(name: "caratlane")
hotels_data = [["77334", "Millora Chennai", "cGN3N0FiVnZjc1E9", "Chennai", "Caratlane"], ["77423", "Millora B 2202", "cjlKV05HalpKWnM9", "Mumbai", "Caratlane"], ["77425", "Millora C 1901 (for Ladies)", "S1VBWmRITzViM1U9", "Mumbai", "Caratlane"], ["77421", "Millora C 501", "Y2R5Nkx6VzNTMWc9", "Mumbai", "Caratlane"], ["77424", "Millora A 1907", "clNlRGZCd2tZbWM9", "Mumbai", "Caratlane"]]
hotels = []
hotels_data.each do |hotel_data|
    hotel = Hotel.create_with(name: hotel_data[1], company: hotel_data[4], location: hotel_data[3], hlx_username: "test", hlx_consumer_key: "50BAE374AAE57673632485D95B365684FD71A3AA", hlx_consumer_secret: "672B68383027B7384D389B99B7F873E563317329", hlx_counter_id: hotel_data[2], hlx_counter_name: "Default Counter", hlx_counter_email: "millora.api@millora.com", hlx_counter_pwd: "Support@12345", hlx_access_key: nil, hlx_access_secret: nil, client_id: client.id).find_or_create_by(hlx_hotel_id: hotel_data[0])
    hotels << hotel
end
mappings = {"Single" => "Single", "Double" => "Single", "Twin" => "Twin", "Queen" => "Single"}
store_room_info(hotels, mappings, true)


client = Client.create_with(display_name: "Titan", logo: "titan.png", logo_2x: "titan_2x.png", access_key: "n9aHuWmGR5IOdgxD").find_or_create_by(name: "titan")
hotels_data = [["77404", "Millora Jaymahal", "cTdyWk9QS1hjeG89", "Bengaluru", "Titan"], ["77406", "Millora Villa 49 Concorde", "bGMzaEIwNnVMRE09", "Bengaluru", "Titan"], ["77443", "Millora VGN", "b0VGUGsxN2hhUkk9", "Chennai", "Titan"]]
hotels = []
hotels_data.each do |hotel_data|
    hotel = Hotel.create_with(name: hotel_data[1], company: hotel_data[4], location: hotel_data[3], hlx_username: "test", hlx_consumer_key: "50BAE374AAE57673632485D95B365684FD71A3AA", hlx_consumer_secret: "672B68383027B7384D389B99B7F873E563317329", hlx_counter_id: hotel_data[2], hlx_counter_name: "Default Counter", hlx_counter_email: "millora.api@millora.com", hlx_counter_pwd: "Support@12345", hlx_access_key: nil, hlx_access_secret: nil, client_id: client.id).find_or_create_by(hlx_hotel_id: hotel_data[0])
    hotels << hotel
end
mappings = {"Queen Size" => "Double", "King Size" => "Double", "Queen Bed" => "Double", "Twin Bed" => "Twin", "Double" => "Double", "Twin" => "Twin"}
store_room_info(hotels, mappings, true)


client = Client.create_with(display_name: "Secure Meters", logo: "secure_meters.png", logo_2x: "secure_meters_2x.png", access_key: "S5UhWoTGJjAKYgXt").find_or_create_by(name: "secure_meters")
hotels_data = [["77429", "Millora A 7", "ZlJvaDQvR1F6Wkk9", "Gurgaon", "Secure Meter"], ["77432", "Millora C 1303", "YmhZS1hVdkRBNlE9", "Ahmedabad", "Secure Meter"], ["77430", "Millora A 56", "UCtwdVAzVTYzcHM9", "Patna", "Secure Meter"], ["77431", "Millora Shanchi Enclave", "K1BjdXVxeTBHNlE9", "Udaipur", "Secure Meter"]]
hotels = []
hotels_data.each do |hotel_data|
    hotel = Hotel.create_with(name: hotel_data[1], company: hotel_data[4], location: hotel_data[3], hlx_username: "test", hlx_consumer_key: "50BAE374AAE57673632485D95B365684FD71A3AA", hlx_consumer_secret: "672B68383027B7384D389B99B7F873E563317329", hlx_counter_id: hotel_data[2], hlx_counter_name: "Default Counter", hlx_counter_email: "millora.api@millora.com", hlx_counter_pwd: "Support@12345", hlx_access_key: nil, hlx_access_secret: nil, client_id: client.id).find_or_create_by(hlx_hotel_id: hotel_data[0])
    hotels << hotel
end
mappings = {"Executive Room" => "Double", "Deluxe Room" => "Double", "Queen Size" => "Double", "Twin Room" => "Twin", "Double" => "Double", "Twin" => "Twin", "Standard Queen" => "Double", "Standard Queen." => "Double", "Superior Queen" => "Double"}
store_room_info(hotels, mappings, true)

