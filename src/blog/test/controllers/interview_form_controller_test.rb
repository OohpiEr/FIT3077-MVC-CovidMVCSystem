require "test_helper"

class InterviewFormControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get interview_form_index_url
    assert_response :success
  end
end
