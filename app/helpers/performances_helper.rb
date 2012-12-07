module PerformancesHelper
  # Return whether a performance filter is currently active
  def filter_active?
    !current_scopes.empty?
  end
end
