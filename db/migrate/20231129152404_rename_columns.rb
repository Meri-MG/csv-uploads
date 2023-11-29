class RenameColumns < ActiveRecord::Migration[7.0]
  def change
    rename_column :student_records, :first_name, :name
    rename_column :student_records, :last_name, :surname
  end
end
