# encoding: utf-8
module ApplicationHelper
  # Return the header logo
  def logo
    image_tag "jumuball.png", id: "header-logo", alt: "Logo von Jugend musiziert",
              height: 120, class: "left"
  end

  # Return a Glyphicon tag
  def icon_tag(name, options = {})
    options[:class] ||= "icon-#{name}"
    content_tag(:i, options) { nil }
  end

  # Return a label with given type and content
  def info_label_tag(content, type = nil)
    class_name = type ? "label label-#{type}" : "label"
    content_tag(:span, class: class_name) { content }
  end

  # Return a badge with given type and content
  def info_badge_tag(content, type = nil)
    class_name = type ? "badge badge-#{type}" : "badge"
    content_tag(:span, class: class_name) { content }
  end

  # Return a flag image based on given country code
  def flag_tag(country_code)
    image_tag "flags/#{country_code}.png", alt: "Flag of #{country_code}", class: "inline-flag"
  end

  # Return a male or female symbol based on given gender
  def gender_symbol(gender)
    if gender == "f"
      "&#9792;".html_safe
    elsif gender == "m"
      "&#9794;".html_safe
    end
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
    # TODO: Append page title?
    # if @title.nil?
    #   base_title
    # else
    #   "#{base_title} &ndash; #{@title}"
    # end
  end

  # Return the full title of the ongoing JuMu contest (e.g. "50. Wettbewerb 'Jugend musiziert'")
  def current_contest_title
    "#{JUMU_SEASON}. Wettbewerb \"Jugend musiziert\""
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

  # Create a <li> link for navigation that can display as active
  def nav_link_to(name, path)
    class_name = current_page?(path) ? "active" : ""

    content_tag(:li, class: class_name) do
      link_to name, path
    end
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
