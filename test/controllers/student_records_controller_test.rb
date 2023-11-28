# frozen_string_literal: true

require 'test_helper'

class StudentRecordsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test '#index before authentication' do
    get student_records_path

    assert_response :redirect
  end

  test '#index after authentication' do
    sign_in users(:bob)

    get student_records_path

    assert_response :success
    assert_text 'Student records'
  end

  test '#import with file of csv format' do
    sign_in users(:bob)

    post import_student_records_path, params: { 
      file: fixture_file_upload('student_records.csv', 'text/csv') 
    }

    assert_redirected_to student_records_path
    assert_equal 'Student records were successfully imported!', flash[:notice]
  end

  test '#import when file is not of csv format' do
    sign_in users(:bob)

    post import_student_records_path, params: { 
      file: fixture_file_upload('fake_student_records.txt', 'text/plain') 
    }

    assert_redirected_to student_records_path
    assert_equal 'Please upload only CSV files', flash[:notice]
  end
end
