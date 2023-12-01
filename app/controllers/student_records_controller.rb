# frozen_string_literal: true

class StudentRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = StudentRecord.ransack(params[:q])
    @pagy, @student_records = pagy(@q.result)
  end

  def import
    file = params[:file]
    return redirect_to student_records_path, notice: "Please upload only CSV files" unless file.content_type == 'text/csv'

    import_result = StudentRecord.import(file)

    if import_result[:success]
      redirect_to student_records_path, notice: 'Student records were successfully imported!'
    else
      flash[:error] = "CSV import failed: #{import_result[:validation_errors].join('; ')}"
      redirect_to student_records_path
    end
  end

  def destroy_all
    StudentRecord.destroy_all

    redirect_to student_records_path, notice: 'All records have been successfully deleted.'
  end

  def download_sample
    file_path = Rails.root.join('public', 'student_records.csv')

    send_file(file_path, filename: 'student_records.csv', type: 'text/csv')
  end
end
