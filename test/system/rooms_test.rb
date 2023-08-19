require "application_system_test_case"

class RoomsTest < ApplicationSystemTestCase
  setup do
    @room = rooms(:one)
  end

  test "visiting the index" do
    visit rooms_url
    assert_selector "h1", text: "Rooms"
  end

  test "should create room" do
    visit rooms_url
    click_on "New room"

    fill_in "Hlx hotel", with: @room.hlx_hotel_id
    fill_in "Hlx occupancy", with: @room.hlx_occupancy
    fill_in "Hlx room", with: @room.hlx_room_id
    fill_in "Hlx room name", with: @room.hlx_room_name
    fill_in "Hlx room type", with: @room.hlx_room_type
    fill_in "Hotel", with: @room.hotel_id
    check "Is active" if @room.is_active
    fill_in "Occupancy", with: @room.occupancy
    fill_in "Room name", with: @room.room_name
    fill_in "Room type", with: @room.room_type
    click_on "Create Room"

    assert_text "Room was successfully created"
    click_on "Back"
  end

  test "should update Room" do
    visit room_url(@room)
    click_on "Edit this room", match: :first

    fill_in "Hlx hotel", with: @room.hlx_hotel_id
    fill_in "Hlx occupancy", with: @room.hlx_occupancy
    fill_in "Hlx room", with: @room.hlx_room_id
    fill_in "Hlx room name", with: @room.hlx_room_name
    fill_in "Hlx room type", with: @room.hlx_room_type
    fill_in "Hotel", with: @room.hotel_id
    check "Is active" if @room.is_active
    fill_in "Occupancy", with: @room.occupancy
    fill_in "Room name", with: @room.room_name
    fill_in "Room type", with: @room.room_type
    click_on "Update Room"

    assert_text "Room was successfully updated"
    click_on "Back"
  end

  test "should destroy Room" do
    visit room_url(@room)
    click_on "Destroy this room", match: :first

    assert_text "Room was successfully destroyed"
  end
end
