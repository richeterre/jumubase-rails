# -*- encoding : utf-8 -*-
class PagesController < ApplicationController

  def home
  end

  def lw # Landeswettbewerb info page
  end

  def competition
  end

  def rules
  end

  def not_found
    render "not_found", status: 404
  end
end
