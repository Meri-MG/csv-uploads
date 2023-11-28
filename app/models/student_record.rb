class StudentRecord < ApplicationRecord
  validates :first_name, :last_name, :grade, :status, presence: true
  validates :email, presence: true, uniqueness: true
end
