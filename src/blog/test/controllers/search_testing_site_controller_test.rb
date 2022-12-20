require "test_helper"

class SearchTestingSiteControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_testing_site_index_url
    assert_response :success
  end
end
