require "test_helper"

class TestingSiteBookingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get testing_site_bookings_index_url
    assert_response :success
  end
end
