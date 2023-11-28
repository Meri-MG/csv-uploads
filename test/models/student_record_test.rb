# frozen_string_literal: true

require "test_helper"

class StudentRecordTest < ActiveSupport::TestCase
  test "validations" do
    student_record = StudentRecord.new(email: '')
    
    assert_not student_record.save
    assert_includes student_record.errors[:first_name], "can't be blank"
    assert_includes student_record.errors[:last_name], "can't be blank"
    assert_includes student_record.errors[:email], "can't be blank"
    assert_includes student_record.errors[:grade], "can't be blank"
    assert_includes student_record.errors[:status], "can't be blank"

    student_record = student_records(:ana_record)
    assert student_record.save

    student_record.update(email: student_records(:david_record).email)
    assert_includes student_record.errors[:email], "has already been taken"
  end

  test '#import' do
    file = File.open(file_fixture('student_records.csv'))

    assert File.exist?(file)

    assert_difference('StudentRecord.count', 3) do
      StudentRecord.import(file)
    end

    assert_equal 'Robert', StudentRecord.last.first_name
    assert_equal 'Doe', StudentRecord.last.last_name
    assert_equal 'robert.doe@example.com', StudentRecord.last.email
    assert_equal 92, StudentRecord.last.test1
    assert_equal 90, StudentRecord.last.final
    assert_equal 'A', StudentRecord.last.grade
    assert_equal 'Pass', StudentRecord.last.status

    StudentRecord.destroy_all
  end
end
