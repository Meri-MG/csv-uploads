# frozen_string_literal: true

class StudentRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @student_records = pagy(StudentRecord.order(surname: :asc))
  end

  def import
    file = params[:file]
    return redirect_to student_records_path, notice: "Please upload only CSV files" unless file.content_type == 'text/csv'

    file = params[:file]
    validation_errors = StudentRecord.import(file)

    if validation_errors.empty?
      redirect_to student_records_path, notice: 'CSV file imported successfully.'
    else
      flash.now[:error] = "CSV import failed: #{validation_errors.join('; ')}"
      redirect_to student_records_path
    end
  end
end
