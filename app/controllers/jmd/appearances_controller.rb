# -*- encoding : utf-8 -*-
class Jmd::AppearancesController < Jmd::BaseController
  before_filter :require_admin if JUMU_ROUND > 1 # Non-admins can edit points only in 1st round
  helper_method :sort_order
  
  def index
    @title = "Ergebnisse verwalten"
    # Show only appearances from the user's competitions
    show_editable_appearances
    # Pass the user's entries for displaying count
    @entries = Entry.current.visible_to(current_user)
  end
  
  def update
    appearance = Appearance.find(params[:id])
    if Entry.visible_to(current_user).include? appearance.entry
      appearance.accessible = :all # Allow editing if user can see appearance
    end
    if appearance.update_attributes(params[:appearance])
      show_editable_appearances # Pass all for table refresh
      # JS view is rendered automatically
    else
      # Return error code 400
      head :bad_request
    end
  end
  
  private
    
    def show_editable_appearances
      @appearances = Entry.current
                          .visible_to(current_user)
                          .category_order
                          .map(&:appearances).flatten
    end
    
    def sort_order
      params[:sort] || "slug"
    end
end