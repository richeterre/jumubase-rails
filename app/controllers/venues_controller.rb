# -*- encoding : utf-8 -*-
class VenuesController < ApplicationController
  
  # Lists entries currently at this venue
  def timetable
    date_array = params.slice(:year, :month, :day).values.map(&:to_i)
    if Date.valid_date?(*date_array)
      @date = Date.new(*date_array)
      @venue = Venue.find(params[:venue_id])
      @entries = Entry.current.at_venue(@venue).on_date(@date)
    else
      render 'pages/not_found'
    end
  end
  
end