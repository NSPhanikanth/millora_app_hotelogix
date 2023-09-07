class HomeController < ApplicationController

    # before_action :authenticate_user!
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
        @hotel_id = params["hotel_id"]
        location = params["location"]

        original_start_date = start_date
        if @hotel_id == 'all'
            hotels = Hotel.where(location: location)
        else
            hotels = Hotel.where(id: @hotel_id)
        end
        @all_hotel_status = {}
        hotels.each do |hotel|
            bookings_response = []
            loop do
                diff = (end_date - start_date).to_i
                diff_considered = diff > 6 ? 6 : diff
                checkin = start_date.strftime("%F")
                checkout = start_date + diff_considered.days
                resp = BookingsHelper.fetch_response(hotel.id, checkin, checkout)
                bookings_response += resp unless resp.nil?
                start_date += (diff_considered + 1).days
                break if start_date > end_date
            end
            @all_hotel_status[hotel.name] = bookings_response.nil? ? {} : BookingsHelper.parse_response(hotel.id, original_start_date, end_date, bookings_response)
        end
        @combined_data = BookingsHelper.combine_data(@all_hotel_status) if @hotel_id == 'all'
        @dates = original_start_date..end_date
        @room_types = RoomType.all
        puts "hotel_status : #{@all_hotel_status}"

        respond_to do |format|
            format.js
        end
        # render json: {status: 'success', message: 'Success', resp: resp}
    end
end