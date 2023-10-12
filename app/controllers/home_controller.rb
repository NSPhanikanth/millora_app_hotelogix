class HomeController < ApplicationController

    # before_action :authenticate_user!
    skip_before_action :verify_authenticity_token
    before_action :set_client

    def index
        if @client.nil?
            render file: Rails.public_path.join('404.html'), status: :not_found, layout: false and return
        end
        @room_types = @client.room_types
        @properties = {}
        @client.hotels.order('name asc').each{|hotel_details|
            location = hotel_details["location"]
            @properties[location] = [] if @properties[location].nil?
            @properties[location].append({'name' => hotel_details["name"], 'id' => hotel_details["id"]})
        }
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
            hotels = @client.hotels.select{|hotel| hotel if hotel.location == location }
        else
            hotels = @client.hotels.select{|hotel| hotel if hotel.id == @hotel_id.to_i }
        end
        @room_types = @client.room_types
        @all_hotel_status = {}
        hotels.each do |hotel|
            bookings_response = []
            loop do
                diff = (end_date - start_date).to_i
                diff_considered = diff > 6 ? 6 : diff
                checkin = start_date.strftime("%F")
                checkout = (start_date + diff_considered.days).strftime("%F")
                resp = BookingsHelper.fetch_response(hotel.id, checkin, checkout)
                bookings_response += resp unless resp.nil?
                start_date += (diff_considered + 1).days
                break if start_date > end_date
            end
            @all_hotel_status[hotel.name] = bookings_response.nil? ? {} : BookingsHelper.parse_response(hotel.id, original_start_date, end_date, bookings_response)
        end
        @combined_data = BookingsHelper.combine_data(@all_hotel_status) if @hotel_id == 'all'
        @dates = original_start_date..end_date

        respond_to do |format|
            format.js
        end
        # render json: {status: 'success', message: 'Success', resp: resp}
    end

    private
    def set_client
        @access_key = params["access_key"]
        @client = Client.includes(:hotels).find_by(access_key: @access_key)
        Rails.logger.info "client identified: #{@client}"
    end

end