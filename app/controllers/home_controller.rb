# frozen_string_literal: true

class HomeController < ApplicationController
  def index; end

  def download_sample
    file_path = Rails.root.join('public', 'student_records.csv')

    send_file(file_path, filename: 'student_records.csv', type: 'text/csv')
  end
end
