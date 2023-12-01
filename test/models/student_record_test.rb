# frozen_string_literal: true

require "test_helper"

class StudentRecordTest < ActiveSupport::TestCase
  test "validations" do
    student_record = StudentRecord.new(email: '')
    
    assert_not student_record.save
    assert_includes student_record.errors[:surname], "can't be blank"
    assert_includes student_record.errors[:name], "can't be blank"
    assert_includes student_record.errors[:email], "can't be blank"
    assert_includes student_record.errors[:grade], "can't be blank"
    assert_includes student_record.errors[:status], "can't be blank"

    student_record = student_records(:ana_record)
    assert student_record.save

    student_record.update(email: student_records(:david_record).email)
    assert_includes student_record.errors[:email], "has already been taken"
    student_record.update(email: 'email.com')
    assert_includes student_record.errors[:email], "is invalid"
  end

  test '#import' do
    file = File.open(file_fixture('student_records.csv'))

    assert File.exist?(file)
    subject = StudentRecord.import(file, users(:bob))
    assert_equal 'Robert', StudentRecord.last.name
    assert_equal 'Doe', StudentRecord.last.surname
    assert_equal 'robert.doe@example.com', StudentRecord.last.email
    assert_equal 92, StudentRecord.last.test1
    assert_equal 90, StudentRecord.last.final
    assert_equal 'A', StudentRecord.last.grade
    assert_equal 'Pass', StudentRecord.last.status

    StudentRecord.destroy_all
  end

  test '#total_scores_sum' do
    assert_equal 457, student_records(:ana_record).total_scores_sum
  end

  test '#total_scores_avg' do
    assert_equal 91, student_records(:ana_record).total_scores_avg
  end

  test '#highest_score' do
    assert_equal 99, student_records(:ana_record).highest_score
  end

  test '#lowest_score' do
    assert_equal 85, student_records(:ana_record).lowest_score
  end

  test '#performance_check' do
    assert_equal 'High', student_records(:ana_record).performance_check
  end
end
