# -*- encoding : utf-8 -*-
class PagesController < ApplicationController
  
  def home
    @title = "Startseite"
  end

  def competition
    @title = "Wettbewerb"
  end

  def rules
    @title = "Ausschreibung"
  end

  def organisation
    @title = "Organisation"
  end
  
  def not_found
    @title = "Seite nicht gefunden"
    render "not_found", status: 404
  end
end
