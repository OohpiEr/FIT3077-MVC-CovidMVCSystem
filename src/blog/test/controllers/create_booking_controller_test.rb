require "test_helper"

class CreateBookingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get create_booking_index_url
    assert_response :success
  end
end
