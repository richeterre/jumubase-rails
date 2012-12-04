# -*- encoding : utf-8 -*-
class Jmd::AppearancesController < Jmd::BaseController
  before_filter :require_admin if JUMU_ROUND > 1 # Non-admins can edit points only in 1st round

  def index
    @performances = Performance.current.visible_to(current_user)
                               .category_order.paginate(page: params[:page], per_page: 15)
  end

  def update
    appearance = Appearance.find(params[:id])
    if Performance.visible_to(current_user).include? appearance.performance
      appearance.accessible = :all # Allow editing if user can see appearance
    end
    if appearance.update_attributes(params[:appearance])
      flash[:success] = "Die Punktzahl für #{appearance.participant.full_name} wurde gespeichert."
    else
      flash[:error] = "Die Punktzahl für #{appearance.participant.full_name} konnte nicht gespeichert werden."
    end
    redirect_to :back
  end
end
