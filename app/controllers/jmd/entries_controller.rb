# -*- encoding : utf-8 -*-
class Jmd::EntriesController < Jmd::BaseController
  before_filter :authenticate, :except => [:new, :create, :search, :edit, :update]
  before_filter :require_admin, :except => [:new, :create, :search, :edit, :update]
  
  def browse
    @title = "Angemeldete Wertungen"
    @entries = Entry.visible_to(current_user)
                    .joins(:category)
                    .category_order
                    .paginate(:page => params[:page], :per_page => 10)
  end
end