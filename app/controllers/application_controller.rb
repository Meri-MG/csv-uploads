# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  def after_sign_in_path_for(resource)
    student_records_path
  end
end
