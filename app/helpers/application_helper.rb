# encoding: utf-8
module ApplicationHelper
  # Return the header logo
  def logo
    image_tag "jumuball.png", :id => "header-logo", :alt => "Logo von Jugend musiziert",
        :height => 120, :class => "left"
  end
  
  # Return an icon image path
  def icon_tag(name, options = nil)
    if options.nil?
      options = { :class => 'icon' }
    elsif options[:class].nil?
      options[:class] = 'icon' # Set icon class
    else
      options[:class] += ' icon' # Append icon class
    end
    image_tag("icons/#{name}.png", options)
  end

  # Convert flash class for use with Twitter Bootstrap
  def flash_class(level)
    case level
    when :alert then "alert"
    when :success then "alert alert-success"
    when :notice then "alert alert-info"
    when :error then "alert alert-error"
    end
  end
  
  # Return a title on a per-page basis
  def title
    base_title ="“Jugend musiziert” Nord- und Osteuropa"
    if @title.nil?
      base_title
    else
      "#{base_title} — #{@title}"
    end
  end

  # Return the full title of the current round (e.g. "Landeswettbewerb 2006")
  def current_round_title
    "#{Round.find_by_level(JUMU_ROUND).name} #{JUMU_YEAR}"
  end

  # Return the name of the current round's host – or all of them for the 1st round
  def current_host_name
    JUMU_ROUND == 2 ? "an der #{JUMU_HOST}" : "an einer Schule der Wettbewerbsregion Nord- und Osteuropa"
  end
  
  # Converts seconds into min'sec format
  def format_duration(seconds)
    min = seconds / 60
    sec = seconds % 60
    "#{min}'#{sec.to_s.rjust(2, "0")}"
  end
  
  # Returns true if the current action matches the name
  def is_active?(controller, action)
    params[:controller] == controller && params[:action] == action
  end
  
  # Create a link that removes a group of fields (e.g. piece or participant)
  def link_to_remove_fields(name, f)
    f.hidden_field(:_destroy) + button_to_function(name, "Application.remove_fields(this)", :class => "btn btn-warning")
  end
  
  # Create a link that adds a new appearance
  def link_to_add_appearance(name, f)
    new_appearance = Appearance.new
    new_appearance.build_participant
    fields = f.fields_for(:appearances, new_appearance, :child_index => "new_appearances") do |builder|
      render("appearance_fields", :f => builder)
    end
    button_to_function(name, "Application.add_fields(this, \"appearance\", \"#{escape_javascript(fields)}\")", :class => "btn")
  end
  
  # Create a link that adds a new piece
  def link_to_add_piece(name, f)
    new_piece = Piece.new
    new_piece.build_composer
    fields = f.fields_for(:pieces, new_piece, :child_index => "new_pieces") do |builder|
      render("piece_fields", :f => builder)
    end
    button_to_function(name, "Application.add_fields(this, \"piece\", \"#{escape_javascript(fields)}\")", :class => "btn")
  end
  
  # Creates a sortable column title
  def sortable(order, title)
    css_class = order == sort_order ? "current" : nil
    link_to title, params.merge(:sort => order), {:class => css_class}
  end
end
