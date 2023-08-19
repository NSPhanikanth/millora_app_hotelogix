require "test_helper"

class RoomsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @room = rooms(:one)
  end

  test "should get index" do
    get rooms_url
    assert_response :success
  end

  test "should get new" do
    get new_room_url
    assert_response :success
  end

  test "should create room" do
    assert_difference("Room.count") do
      post rooms_url, params: { room: { hlx_hotel_id: @room.hlx_hotel_id, hlx_occupancy: @room.hlx_occupancy, hlx_room_id: @room.hlx_room_id, hlx_room_name: @room.hlx_room_name, hlx_room_type: @room.hlx_room_type, hotel_id: @room.hotel_id, is_active: @room.is_active, occupancy: @room.occupancy, room_name: @room.room_name, room_type: @room.room_type } }
    end

    assert_redirected_to room_url(Room.last)
  end

  test "should show room" do
    get room_url(@room)
    assert_response :success
  end

  test "should get edit" do
    get edit_room_url(@room)
    assert_response :success
  end

  test "should update room" do
    patch room_url(@room), params: { room: { hlx_hotel_id: @room.hlx_hotel_id, hlx_occupancy: @room.hlx_occupancy, hlx_room_id: @room.hlx_room_id, hlx_room_name: @room.hlx_room_name, hlx_room_type: @room.hlx_room_type, hotel_id: @room.hotel_id, is_active: @room.is_active, occupancy: @room.occupancy, room_name: @room.room_name, room_type: @room.room_type } }
    assert_redirected_to room_url(@room)
  end

  test "should destroy room" do
    assert_difference("Room.count", -1) do
      delete room_url(@room)
    end

    assert_redirected_to rooms_url
  end
end
