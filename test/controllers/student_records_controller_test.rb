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
  end

  test '#import with file of csv format' do
    sign_in users(:bob)

    assert_difference('StudentRecord.count', 3) do
      post import_student_records_path, params: { 
        file: fixture_file_upload('student_records.csv', 'text/csv') 
      }
    end

    assert_redirected_to student_records_path
    assert_equal 'Student records were successfully imported!', flash[:notice]
  end

  test '#import when file is not of csv format' do
    sign_in users(:bob)

    assert_no_difference('StudentRecord.count') do
      post import_student_records_path, params: { 
        file: fixture_file_upload('fake_student_records.txt', 'text/plain') 
      }
    end

    assert_redirected_to student_records_path
    assert_equal 'Please upload CSV files', flash[:notice]
  end

  test '#import fails' do
    sign_in users(:bob)

    assert_no_difference('StudentRecord.count') do
      post import_student_records_path, params: { 
        file: fixture_file_upload('extra_column_student_records.csv', 'text/csv') 
      }
    end

    assert_redirected_to student_records_path
    assert_equal 'CSV import failed: Unexpected columns in row: fake', flash[:error]
  end

  test '#destroy_all' do
    sign_in users(:sam)

    assert_difference('StudentRecord.count', -2) do
      delete destroy_all_student_records_path
    end

    assert_redirected_to student_records_path
  end
end
