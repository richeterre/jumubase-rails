# -*- encoding : utf-8 -*-
class Jmd::EntriesController < Jmd::BaseController
  before_filter :authenticate
  
  def browse
    @title = "Angemeldete Wertungen"
    @entries = Entry.visible_to(current_user)
                    .joins(:category)
                    .category_order
                    .paginate(:page => params[:page], :per_page => 10)
  end
end