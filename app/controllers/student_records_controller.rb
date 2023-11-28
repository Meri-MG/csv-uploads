# frozen_string_literal: true

class StudentRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @student_records = pagy(StudentRecord.all)
  end

  def import
    file = params[:file]
    return redirect_to student_records_path, notice: "Please upload only CSV files" unless file.content_type == 'text/csv'

    StudentRecord.import(file)

    redirect_to student_records_path, notice: "Student records were successfully imported!"
  end
end
