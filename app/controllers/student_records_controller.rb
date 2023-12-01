# frozen_string_literal: true

class StudentRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = current_user.student_records.ransack(params[:q])
    @pagy, @student_records = pagy(@q.result)
  end

  def import
    file = params[:file]
    if !file || file.content_type != 'text/csv'
      return redirect_to student_records_path, notice: "Please upload CSV files"
    end

    import_result = StudentRecord.import(file, current_user)

    if import_result[:success]
      redirect_to student_records_path, notice: 'Student records were successfully imported!'
    else
      flash[:error] = "CSV import failed: #{import_result[:validation_errors].join('; ')}"
      redirect_to student_records_path
    end
  end

  def destroy_all
    current_user.student_records.destroy_all

    redirect_to student_records_path, notice: 'All records have been successfully deleted.'
  end
end
