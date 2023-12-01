# frozen_string_literal: true

require 'csv'

class StudentRecord < ApplicationRecord
  scope :sorted_results, ->(sort_option) do
    case sort_option
    when 'name'
      order(:name)
    when 'final'
      order(final: :desc)
    else
      order(:surname)
    end
  end

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :name, :surname, :grade, :status, presence: true
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: true
  validates :test1, :test2, :test3, :test4, :final, numericality:  { in: 0..100 } 

  def self.import(file)
    result = { success: false, validation_errors: [] }
    required_columns = new.required_columns
    csv = new.csv_file(file)
    unexpected_columns = csv.headers - required_columns
    missing_columns = required_columns - csv.headers

    if unexpected_columns.any?
      result[:validation_errors] << "Unexpected columns in row: #{unexpected_columns.join(', ')}"
    elsif missing_columns.any?
      result[:validation_errors] << "Missing columns in row: #{missing_columns.join(', ')}"
    else
      csv.each_with_index do |row, i|
        student_record = new(row.to_hash)

        unless student_record.save
          result[:validation_errors].concat(["Row #{i + 1}: #{student_record.errors.full_messages.join(', ')}, delete the records and import again"])
          break
        end
      end

      result[:success] = result[:validation_errors].empty?
    end

    result
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

  def performance_check
    case total_scores_avg
    when 90..100
      'High'
    when 70..90
      'Medium'
    else
      'Low'
    end
  end

  def csv_file(file)
    file = File.open(file)
    csv = CSV.parse(file, headers: true)
    csv
  end

  def required_columns
    %w[name surname email test1 test2 test3 test4 final grade status]
  end

  def self.ransackable_attributes(_auth_object = nil)
    [
      "grade",
      "status",
      "name",
      "surname",
      "final"
    ]
  end

  private

  def student_scores
    [test1, test2, test3, test4, final]
  end
end
