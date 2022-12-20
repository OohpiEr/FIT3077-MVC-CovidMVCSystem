require "test_helper"

class SearchBookingControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_booking_index_url
    assert_response :success
  end
end
