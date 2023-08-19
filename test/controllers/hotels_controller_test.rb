require "test_helper"

class HotelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @hotel = hotels(:one)
  end

  test "should get index" do
    get hotels_url
    assert_response :success
  end

  test "should get new" do
    get new_hotel_url
    assert_response :success
  end

  test "should create hotel" do
    assert_difference("Hotel.count") do
      post hotels_url, params: { hotel: { company: @hotel.company, hlx_access_key: @hotel.hlx_access_key, hlx_access_secret: @hotel.hlx_access_secret, hlx_consumer_key: @hotel.hlx_consumer_key, hlx_consumer_secret: @hotel.hlx_consumer_secret, hlx_counter_email: @hotel.hlx_counter_email, hlx_counter_id: @hotel.hlx_counter_id, hlx_counter_name: @hotel.hlx_counter_name, hlx_counter_pwd: @hotel.hlx_counter_pwd, hlx_hotel_id: @hotel.hlx_hotel_id, hlx_username: @hotel.hlx_username, is_active: @hotel.is_active, location: @hotel.location, name: @hotel.name } }
    end

    assert_redirected_to hotel_url(Hotel.last)
  end

  test "should show hotel" do
    get hotel_url(@hotel)
    assert_response :success
  end

  test "should get edit" do
    get edit_hotel_url(@hotel)
    assert_response :success
  end

  test "should update hotel" do
    patch hotel_url(@hotel), params: { hotel: { company: @hotel.company, hlx_access_key: @hotel.hlx_access_key, hlx_access_secret: @hotel.hlx_access_secret, hlx_consumer_key: @hotel.hlx_consumer_key, hlx_consumer_secret: @hotel.hlx_consumer_secret, hlx_counter_email: @hotel.hlx_counter_email, hlx_counter_id: @hotel.hlx_counter_id, hlx_counter_name: @hotel.hlx_counter_name, hlx_counter_pwd: @hotel.hlx_counter_pwd, hlx_hotel_id: @hotel.hlx_hotel_id, hlx_username: @hotel.hlx_username, is_active: @hotel.is_active, location: @hotel.location, name: @hotel.name } }
    assert_redirected_to hotel_url(@hotel)
  end

  test "should destroy hotel" do
    assert_difference("Hotel.count", -1) do
      delete hotel_url(@hotel)
    end

    assert_redirected_to hotels_url
  end
end
