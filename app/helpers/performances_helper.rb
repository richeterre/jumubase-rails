module PerformancesHelper
  # Return whether a performance filter is currently active
  def filter_active?
    !current_scopes.empty?
  end

  # Return a random number for naming generated PDFs
  def random_number
    code = (0..9).to_a.shuffle[0..6].join
  end
end
