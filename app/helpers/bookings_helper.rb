module BookingsHelper
    def self.parse_response(filepath)
        # x = File.open("/Users/phani/phani_test_this/split_booking_details.json").read
        begin
            x = File.open(filepath).read
        rescue => e
            return []
        end
        x = JSON.parse(x)
        bookings = x["hotelogix"]["response"]["bookings"]
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
end
