require "test_helper"

class ExerciseSetControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get exercise_set_create_url
    assert_response :success
  end

  test "should get update" do
    get exercise_set_update_url
    assert_response :success
  end

  test "should get destroy" do
    get exercise_set_destroy_url
    assert_response :success
  end
end
