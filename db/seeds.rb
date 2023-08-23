# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

user = User.create_with(password: "123456", username: "test1").find_or_create_by(email: "test@gmail.com")
single_room = RoomType.create_with(hlx_room_type_id: 'aE1LeTFReTdqMzg9', hlx_room_type_name: 'Double room A/C', max_occupancy: 2, is_split_allowed: false).find_or_create_by(name: 'Single')
double_room = RoomType.create_with(hlx_room_type_id: 'aE1LeTFReTdqMzg9', hlx_room_type_name: 'Double room A/C', max_occupancy: 2, is_split_allowed: false).find_or_create_by(name: 'Double')
twin_room = RoomType.create_with(hlx_room_type_id: 'aE1LeTFReTdqMzg9', hlx_room_type_name: 'Double room A/C', max_occupancy: 2, is_split_allowed: true).find_or_create_by(name: 'Twin')
hotel = Hotel.create_with(name: "Hotelogix Hotel", company: "Caratlane", location: "Chennai", hlx_username: "test", hlx_consumer_key: "D401B02273AD373F95518848C5288572F073A07E", hlx_consumer_secret: "3DD5CDF28FE6B6DD47A9AE9BF011AE935E0065B3", hlx_counter_id: "eWtyaWk3TFpxbXc9", hlx_counter_name: "Default Counter", hlx_counter_email: "praveena.thantry@gmail.com", hlx_counter_pwd: "", hlx_access_key: nil, hlx_access_secret: nil ).find_or_create_by(hlx_hotel_id: "27143")

Room.create(room_name: "DLX101", hotel_id: hotel.id, hlx_room_id: "MVV4VXpUcEd5cUk9", hlx_room_name: "DLX101", is_active: true, room_type_id: single_room.id)
Room.create(room_name: "DLX102", hotel_id: hotel.id, hlx_room_id: "VXRRWXkrVDlRMUU9", hlx_room_name: "DLX102", is_active: true, room_type_id: single_room.id)
Room.create(room_name: "DLX103", hotel_id: hotel.id, hlx_room_id: "Q1pUVUVFckdKazQ9", hlx_room_name: "DLX103", is_active: true, room_type_id: single_room.id)
Room.create(room_name: "DLX104", hotel_id: hotel.id, hlx_room_id: "QUR1KzR4UG94b0U9", hlx_room_name: "DLX104", is_active: true, room_type_id: single_room.id)
Room.create(room_name: "DLX105", hotel_id: hotel.id, hlx_room_id: "T1lGYnJnWjhscGs9", hlx_room_name: "DLX105", is_active: true, room_type_id: double_room.id)
Room.create(room_name: "DLX106", hotel_id: hotel.id, hlx_room_id: "QVMrL2V2ZjhlVEE9", hlx_room_name: "DLX106", is_active: true, room_type_id: double_room.id)
Room.create(room_name: "DLX107", hotel_id: hotel.id, hlx_room_id: "NjVXWkJncUgxTUk9", hlx_room_name: "DLX107", is_active: true, room_type_id: double_room.id)
Room.create(room_name: "DLX108", hotel_id: hotel.id, hlx_room_id: "TndWWlRhSTV6MG89", hlx_room_name: "DLX108", is_active: true, room_type_id: twin_room.id)
Room.create(room_name: "DLX109", hotel_id: hotel.id, hlx_room_id: "ME9PSlJvY0U0Tjg9", hlx_room_name: "DLX109", is_active: true, room_type_id: twin_room.id)
Room.create(room_name: "DLX110", hotel_id: hotel.id, hlx_room_id: "UkF2all1LzZrT1U9", hlx_room_name: "DLX110", is_active: true, room_type_id: twin_room.id)