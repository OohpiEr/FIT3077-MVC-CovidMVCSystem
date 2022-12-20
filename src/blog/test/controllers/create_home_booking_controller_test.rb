require "test_helper"

class CreateHomeBookingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get create_home_booking_index_url
    assert_response :success
  end
end
