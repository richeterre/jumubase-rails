# -*- encoding : utf-8 -*-
class Jmd::AppearancesController < Jmd::BaseController

  # Set up filters
  has_scope :in_competition, only: :index
  has_scope :advanced_from_competition, only: :index
  has_scope :in_category, only: :index
  has_scope :in_age_group, only: :index

  def index
    authorize! :update, Performance # Users can see points only if authorized to change them

    @performances = apply_scopes(Performance).accessible_by(current_ability).current
                                .browsing_order
                                .paginate(page: params[:page], per_page: 15)
  end

  def update
    @appearance = Appearance.find(params[:id])
    authorize! :update, @appearance.performance # Authorize through associated performance

    @appearance.points = params[:appearance][:points]
    if @appearance.save
      flash[:success] = "Die Punktzahl für #{@appearance.participant.full_name} wurde gespeichert."
    else
      flash[:error] = "Die Punktzahl für #{@appearance.participant.full_name} konnte nicht gespeichert werden."
    end
    redirect_to :back
  end
end
