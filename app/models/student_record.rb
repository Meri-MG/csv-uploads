# frozen_string_literal: true

require 'csv'

class StudentRecord < ApplicationRecord
  validates :name, :surname, :grade, :status, presence: true
  validates :email, presence: true, uniqueness: true
  validates :test2, :test3, :test4, :final, numericality: { only_integer: true }

  def self.import(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true)
    required_columns = ['name', 'surname', 'email', 'test1', 'test2', 'test3', 'test4', 'final', 'grade', 'status']

    validation_errors = []

    csv.each do |row|
      unexpected_columns = row.headers - required_columns
      missing_columns = required_columns - row.headers

      if unexpected_columns.any?
        validation_errors << "Unexpected columns in row: #{unexpected_columns.join(', ')}"
      elsif missing_columns.any?
        validation_errors << "Missing columns in row: #{missing_columns.join(', ')}"
      else
        student_record = new(row.to_hash)

        unless student_record.save
          validation_errors.concat(student_record.errors.full_messages)
        end
      end
    end

    validation_errors
  end

  def total_scores_sum
    test1 + test2 + test3 + test4 + final
  end

  def total_scores_avg
    total_scores_sum / 5
  end

  def highest_score
    student_scores.max
  end

  def lowest_score
    student_scores.min
  end

  private

  def student_scores
    [test1, test2, test3, test4, final]
  end
end
