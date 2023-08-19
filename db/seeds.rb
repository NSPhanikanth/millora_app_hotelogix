# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create_with(password: "123456", username: "test1").find_or_create_by(email: "test@gmail.com")

hotel = Hotel.create_with(name: "Hotelogix Hotel", company: "Caratlane", location: "Chennai", hlx_username: "test", hlx_consumer_key: "D401B02273AD373F95518848C5288572F073A07E", hlx_consumer_secret: "3DD5CDF28FE6B6DD47A9AE9BF011AE935E0065B3", hlx_counter_id: "eWtyaWk3TFpxbXc9", hlx_counter_name: "Default Counter", hlx_counter_email: "praveena.thantry@gmail.com", hlx_counter_pwd: "", hlx_access_key: nil, hlx_access_secret: nil ).find_or_create_by(hlx_hotel_id: "27143")

[
    {
        "id" => "MVV4VXpUcEd5cUk9",
        "name" => "DLX101",
        "status" => "C",
        "availStatus" => "OCCUPIED",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => " watch returned to guest"
    },
    {
        "id" => "VXRRWXkrVDlRMUU9",
        "name" => "DLX102",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "Handle with supreme care"
    },
    {
        "id" => "Q1pUVUVFckdKazQ9",
        "name" => "DLX103",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "WC9URmVtTXhjTlU9",
        "remarks" => "room to be clean"
    },
    {
        "id" => "QUR1KzR4UG94b0U9",
        "name" => "DLX104",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "wallet on table"
    },
    {
        "id" => "T1lGYnJnWjhscGs9",
        "name" => "DLX105",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "Marked DND"
    },
    {
        "id" => "QVMrL2V2ZjhlVEE9",
        "name" => "DLX106",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "---"
    },
    {
        "id" => "NjVXWkJncUgxTUk9",
        "name" => "DLX107",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "---"
    },
    {
        "id" => "TndWWlRhSTV6MG89",
        "name" => "DLX108",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "---"
    },
    {
        "id" => "ME9PSlJvY0U0Tjg9",
        "name" => "DLX109",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "---"
    },
    {
        "id" => "UkF2all1LzZrT1U9",
        "name" => "DLX110",
        "status" => "C",
        "availStatus" => "AVAILABLE",
        "floorId" => "6320",
        "blockId" => "",
        "assignedTo" => "eWdZbzA0aFRuejA9",
        "remarks" => "---"
    }
].each_with_index{|room_details, idx|
	room_type = idx < 4 ? "Single" : (idx < 7 ? "Double" : "Twin")
	occupancy = room_type == "Single" ? 1 : 2
	split_allowed = room_type == "Twin"
	Room.create_with(room_name: room_details["name"], room_type: room_type, occupancy: occupancy, hlx_hotel_id: hotel.hlx_hotel_id, hlx_room_name: room_details["name"], hlx_room_type: "Double room A/C", hlx_occupancy: 2, is_split_allowed: split_allowed).find_or_create_by(hotel_id: hotel.id, hlx_room_id: room_details["id"])
}


 