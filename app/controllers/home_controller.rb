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
        @room_types = RoomType.all
    end

    def submit
        checkin = params["checkin"].strip
        checkout = params["checkout"].strip
        start_date = Date.parse(checkin)
        end_date = Date.parse(checkout)
        hotel_id = params["hotel_id"]

        bookings_response = []
        original_start_date = start_date
        loop do
            diff = (end_date - start_date).to_i
            diff_considered = diff > 6 ? 6 : diff
            checkin = start_date.strftime("%F")
            checkout = start_date + diff_considered.days
            resp = BookingsHelper.fetch_response(hotel_id, checkin, checkout)
            bookings_response += resp unless resp.nil?
            start_date += (diff_considered + 1).days
            break if start_date > end_date
        end
        @hotel_status = bookings_response.nil? ? {} : BookingsHelper.parse_response(original_start_date, end_date, bookings_response)
        @dates = original_start_date..end_date
        @room_types = RoomType.all
        puts "hotel_status : #{@hotel_status}"

        respond_to do |format|
            format.js
        end
        # render json: {status: 'success', message: 'Success', resp: resp}
    end
end