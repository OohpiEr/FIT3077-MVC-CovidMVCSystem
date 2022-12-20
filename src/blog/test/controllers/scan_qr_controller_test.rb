require "test_helper"

class ScanQrControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get scan_qr_index_url
    assert_response :success
  end
end
