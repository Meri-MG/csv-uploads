# frozen_string_literal: true

require 'csv'

class StudentRecord < ApplicationRecord
  validates :first_name, :last_name, :grade, :status, presence: true
  validates :email, presence: true, uniqueness: true

  def self.import(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true, col_sep: ';')

    csv.each do |row|
      student_records = {}
      student_records[:first_name] = row['First name']
      student_records[:last_name] = row['Last name']
      student_records[:email] = row['Email']
      student_records[:test1] = row['Test1']
      student_records[:test2] = row['Test2']
      student_records[:test3] = row['Test3']
      student_records[:test4] = row['Test4']
      student_records[:final] = row['Final']
      student_records[:grade] = row['Grade']
      student_records[:status] = row['Status']
      StudentRecord.find_or_create_by!(student_records)
    end
  end
end
