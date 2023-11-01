module ReportsHelper

    def self.daily_report(report_date)
        clients = Client.includes(hotels: :rooms).all
        clients_data = []
        clients.each do |client|
            data = []
            location_data = {}
            properties_count = 0
            client.hotels.each do |hotel|
                original_start_date = report_date.in_time_zone("Chennai").beginning_of_month.to_date
                start_date = report_date.in_time_zone("Chennai").beginning_of_month.to_date
                end_date = report_date.in_time_zone("Chennai").end_of_month.to_date
                hotel_data = {}
                location_data[hotel.location] = [] if location_data[hotel.location].nil?
                hotel_status = []
                loop do
                    diff = (end_date - start_date).to_i
                    diff_considered = diff > 6 ? 6 : diff
                    checkin = start_date.strftime("%F")
                    checkout = (start_date + diff_considered.days).strftime("%F")
                    resp = BookingsHelper.fetch_hotel_status(hotel.id, checkin, checkout)
                    hotel_status += resp unless resp.nil?
                    start_date += (diff_considered + 1).days
                    break if start_date > end_date
                end
                final_response = ReportsHelper.parse_response(hotel, original_start_date, end_date, report_date, hotel_status)
                location_data[hotel.location] << {"hotel_name" => hotel.name}.merge(final_response)
                properties_count += 1
            end
            location_data.each do |location_name, location_info|
                data << {"location" => location_name, "data" => location_info}
            end
            clients_data << {"name" => client.display_name, "data" => data, "properties_count" => properties_count}
        end
        return clients_data
    end

    def self.parse_response(hotel, start_date, end_date, report_date, response)
        occupied_rooms = {}
        occ_day = 0
        occ_mtd = 0
        occ_eom = 0
        total_rooms = 0
        occupied_rooms_on_date = 0
        occupied_rooms_till_date = 0
        occupied_rooms_till_end = 0
        total_room_count = 0
        total_room_count_till_date = 0
        total_rooms_on_date = 0
        todays_date = report_date
        (start_date..end_date).each do |selected_date|
            occupied_rooms[selected_date.strftime("%F")] = 0
        end
        response.each do |resp|
            puts "resp: #{resp}"
            date_ = resp["date"]
            formatted_date = DateTime.parse(date_).to_date
            room_types = resp["roomTypes"] || []
            total_bookings_on_date = 0
            total_rooms_on_date = 0
            room_types.each do |room_type|
                rooms_count = (room_type["totalRooms"].to_i || 0) rescue 0
                bookings_count = (room_type["totalBookins"].to_i || 0) rescue 0
                total_bookings_on_date += bookings_count
                total_rooms += rooms_count
                occupied_rooms_on_date += bookings_count if todays_date == formatted_date
                occupied_rooms_till_date += bookings_count if todays_date <= formatted_date
                occupied_rooms_till_end += bookings_count
                total_rooms_on_date += rooms_count if todays_date == formatted_date
                total_room_count_till_date += rooms_count if todays_date <= formatted_date
                total_room_count += rooms_count
            end
            occupied_rooms[date_] = total_bookings_on_date
        end
        occ_day = total_rooms_on_date == 0 ? 0 : (100 * occupied_rooms_on_date.to_f / total_rooms_on_date).round(2)
        occ_eom = total_room_count == 0 ? 0 : (100 * occupied_rooms_till_end.to_f / total_room_count).round(2)
        occ_mtd = total_room_count_till_date == 0 ? 0 : (100 * occupied_rooms_till_date.to_f / total_room_count_till_date).round(2)

        return {"total_rooms" => hotel.rooms.count, "occupied_rooms" => occupied_rooms, "occ_day" => occ_day, "occ_mtd" => occ_mtd, "occ_eom" => occ_eom}
    end

    def self.create_report(data, filepath, report_date, start_date = nil, end_date = nil)
        start_date = report_date.in_time_zone("Chennai").beginning_of_month.to_date if start_date.nil?
        end_date = report_date.in_time_zone("Chennai").end_of_month.to_date if end_date.nil?
        require 'axlsx'
        pck = Axlsx::Package.new
        wb = pck.workbook
        header_style = wb.styles.add_style(b: true, bg_color: 'c9daf8', alignment: { horizontal: :center, vertical: :center }, border: {color: '000000', style: :thin} )
        vc_style = wb.styles.add_style(alignment: { vertical: :center }, border: {color: '000000', style: :thin} )
        meta_style = wb.styles.add_style(b: true, bg_color: 'fff2cc', alignment: { vertical: :center }, border: {color: '000000', style: :thin} )
        wb.add_worksheet(name: 'Daily Report') do |sheet|            
            dates_row = ['Company', 'City', 'Property', 'Rooms']
            days_row = ['', '', '', '']
            days_count = 0
            (start_date..end_date).each do |date|
                dates_row << date.strftime("%d")
                days_row << date.strftime("%a")
                days_count += 1
            end
            dates_row += ['Occ for Day', 'Occ MTD', 'Occ EOM']
            days_row += ['', '', '']
            sheet.add_row dates_row, style: header_style
            sheet.add_row days_row, style: header_style
            cells_to_merge = []
            letter = 'A'
            1.upto(4) { cells_to_merge << letter.dup ; letter.next! }
            1.upto(days_count) do
                letter.next!
            end
            1.upto(3) { cells_to_merge << letter.dup ; letter.next!}
            cells_to_merge.each {|letter| sheet.merge_cells("#{letter}1:#{letter}2") }
            row_index = 3
            location_index = 3
            data.each_with_index do |client_data, client_idx|
                # puts "client_data: #{client_data}"
                next if client_data["properties_count"] == 0
                total_count = 0
                total_count_till_date = 0
                total_count_on_date = 0
                occupied_count = 0
                occupied_count_till_date = 0
                occupied_count_on_date = 0

                (client_data["data"] || []).each_with_index do |location_data, location_idx|
                    puts "location_index: #{location_index}"
                    # puts "location_data: #{location_data}"
                    hotels_data = location_data["data"] || []
                    hotels_data.each do |hotel_data|
                        data_row = [client_data["name"], location_data["location"], hotel_data["hotel_name"], hotel_data["total_rooms"]]
                        (start_date..end_date).each do |date|
                            occupied_rooms = ((hotel_data["occupied_rooms"][date.strftime("%F")] || 0) rescue 0)
                            data_row << occupied_rooms
                            if date == report_date
                                total_count_on_date += hotel_data["total_rooms"]
                                total_count_till_date += hotel_data["total_rooms"]
                                occupied_count_on_date += occupied_rooms
                                occupied_count_till_date += occupied_rooms
                            elsif date < report_date
                                total_count_till_date += hotel_data["total_rooms"]
                                occupied_count_till_date += occupied_rooms
                            end
                            occupied_count += occupied_rooms
                            total_count += hotel_data["total_rooms"]
                        end
                        data_row << hotel_data["occ_day"]
                        data_row << hotel_data["occ_mtd"]
                        data_row << hotel_data["occ_eom"]
                        sheet.add_row data_row, style: vc_style
                    end
                    location_last_row_index = location_index + hotels_data.length - 1
                    sheet.merge_cells("B#{location_index}:B#{location_last_row_index}")
                    puts "Merging from : B#{location_index}:B#{location_last_row_index}"
                    location_index += hotels_data.length
                end
                clients_last_row_index = row_index + (client_data["properties_count"] || 0) - 1
                meta_row = ['', 'Total', '']
                letter = 'D'
                1.upto(days_count + 1) do
                    meta_row << "=SUM(#{letter}#{row_index}:#{letter}#{clients_last_row_index})"
                    letter.next!
                end
                per1 = total_count_on_date == 0 ? 0 : 100 * occupied_count_on_date.to_f / total_count_on_date
                per2 = total_count_till_date == 0 ? 0 : 100 * occupied_count_till_date.to_f / total_count_till_date
                per3 = total_count == 0 ? 0 : 100 * occupied_count.to_f / total_count
                meta_row += [per1.round(2), per2.round(2), per3.round(2)]
                sheet.add_row meta_row, style: meta_style
                sheet.merge_cells("A#{row_index}:A#{clients_last_row_index + 1}")
                puts "Merging from : A#{row_index}:A#{clients_last_row_index + 1}"
                row_index += (client_data["properties_count"] || 0)
                sheet.merge_cells("B#{location_index}:C#{location_index}")
                puts "Merging from : B#{location_index}:C#{location_index}"
                row_index += 1 # Including Meta Row Count
                location_index += 1 # Including Meta Row Count
            end
        end
        pck.serialize filepath
    end
end
