# -*- encoding : utf-8 -*-
class Jmd::AppearancesController < Jmd::BaseController

  load_and_authorize_resource :performance, parent: false, only: :index

  def index
    @performances = @performances.category_order
                                 .paginate(page: params[:page], per_page: 15)
  end

  def update
    # @appearance is fetched by CanCan
    @appearance = Appearance.find(params[:id])
    authorize! :update, @appearance.performance

    @appearance.points = params[:appearance][:points]
    if @appearance.save
      flash[:success] = "Die Punktzahl für #{@appearance.participant.full_name} wurde gespeichert."
    else
      flash[:error] = "Die Punktzahl für #{@appearance.participant.full_name} konnte nicht gespeichert werden."
    end
    redirect_to :back
  end
end
