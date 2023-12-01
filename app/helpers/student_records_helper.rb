module StudentRecordsHelper
  def grade_options_to_select
    %w[A B C D E F]
  end

  def status_options_to_select
    %w[Pass Fail]
  end

  def sort_options_to_select
    %w[name surname final]
  end
end