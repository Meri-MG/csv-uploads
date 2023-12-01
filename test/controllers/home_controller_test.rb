# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test '#index' do
    get root_path

    assert_response :success
    assert_text 'Sign up'
    assert_text 'Log in'
    assert_no_text 'Log out'
  end

  test '#index with the signed in user' do
    sign_in users(:bob)
    get root_path

    assert_response :success
    assert_text 'logout'
    assert_no_text 'Log in'
  end
end
