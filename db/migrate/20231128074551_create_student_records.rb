# frozen_string_literal: true

class CreateStudentRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :student_records do |t|
      t.string :last_name, null: false, default: ''
      t.string :first_name, null: false, default: ''
      t.string :email, null: false, default: '', index: true, unique: true
      t.integer :test1
      t.integer :test2
      t.integer :test3
      t.integer :test4
      t.integer :final
      t.string :grade, null: false, default: ''
      t.string :status, null: false, default: ''

      t.timestamps
    end
  end
end
