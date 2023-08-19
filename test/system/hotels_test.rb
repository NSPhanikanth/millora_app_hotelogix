require "application_system_test_case"

class HotelsTest < ApplicationSystemTestCase
  setup do
    @hotel = hotels(:one)
  end

  test "visiting the index" do
    visit hotels_url
    assert_selector "h1", text: "Hotels"
  end

  test "should create hotel" do
    visit hotels_url
    click_on "New hotel"

    fill_in "Company", with: @hotel.company
    fill_in "Hlx access key", with: @hotel.hlx_access_key
    fill_in "Hlx access secret", with: @hotel.hlx_access_secret
    fill_in "Hlx consumer key", with: @hotel.hlx_consumer_key
    fill_in "Hlx consumer secret", with: @hotel.hlx_consumer_secret
    fill_in "Hlx counter email", with: @hotel.hlx_counter_email
    fill_in "Hlx counter", with: @hotel.hlx_counter_id
    fill_in "Hlx counter name", with: @hotel.hlx_counter_name
    fill_in "Hlx counter pwd", with: @hotel.hlx_counter_pwd
    fill_in "Hlx hotel", with: @hotel.hlx_hotel_id
    fill_in "Hlx username", with: @hotel.hlx_username
    check "Is active" if @hotel.is_active
    fill_in "Location", with: @hotel.location
    fill_in "Name", with: @hotel.name
    click_on "Create Hotel"

    assert_text "Hotel was successfully created"
    click_on "Back"
  end

  test "should update Hotel" do
    visit hotel_url(@hotel)
    click_on "Edit this hotel", match: :first

    fill_in "Company", with: @hotel.company
    fill_in "Hlx access key", with: @hotel.hlx_access_key
    fill_in "Hlx access secret", with: @hotel.hlx_access_secret
    fill_in "Hlx consumer key", with: @hotel.hlx_consumer_key
    fill_in "Hlx consumer secret", with: @hotel.hlx_consumer_secret
    fill_in "Hlx counter email", with: @hotel.hlx_counter_email
    fill_in "Hlx counter", with: @hotel.hlx_counter_id
    fill_in "Hlx counter name", with: @hotel.hlx_counter_name
    fill_in "Hlx counter pwd", with: @hotel.hlx_counter_pwd
    fill_in "Hlx hotel", with: @hotel.hlx_hotel_id
    fill_in "Hlx username", with: @hotel.hlx_username
    check "Is active" if @hotel.is_active
    fill_in "Location", with: @hotel.location
    fill_in "Name", with: @hotel.name
    click_on "Update Hotel"

    assert_text "Hotel was successfully updated"
    click_on "Back"
  end

  test "should destroy Hotel" do
    visit hotel_url(@hotel)
    click_on "Destroy this hotel", match: :first

    assert_text "Hotel was successfully destroyed"
  end
end
