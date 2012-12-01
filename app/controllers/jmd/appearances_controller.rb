# -*- encoding : utf-8 -*-
class Jmd::AppearancesController < Jmd::BaseController
  before_filter :require_admin if JUMU_ROUND > 1 # Non-admins can edit points only in 1st round

  def index
    @performances = Performance.current.visible_to(current_user)
  end

  # def update
  #   appearance = Appearance.find(params[:id])
  #   if Entry.visible_to(current_user).include? appearance.entry
  #     appearance.accessible = :all # Allow editing if user can see appearance
  #   end
  #   if appearance.update_attributes(params[:appearance])
  #     show_editable_appearances # Pass all for table refresh
  #     # JS view is rendered automatically
  #   else
  #     # Return error code 400
  #     head :bad_request
  #   end
  # end
end
