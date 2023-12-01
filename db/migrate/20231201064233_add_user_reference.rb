# frozen_string_literal: true

class AddUserReference < ActiveRecord::Migration[7.0]
  def change
    add_reference :student_records, :user, foreign_key: true
  end
end
