json.array! @contests do |c|
  json.id c.id.to_s
  json.name c.name
  json.host_country c.host.country_code.upcase
  json.time_zone c.host.time_zone.name
  json.start_date c.begins.to_time(:utc) - c.host.time_zone.utc_offset
  json.end_date c.ends.to_time(:utc) - c.host.time_zone.utc_offset

  json.venues c.used_venues do |venue|
    json.id venue.id.to_s
    json.name venue.name
  end

  json.contest_categories c.contest_categories.select { |cc| cc.performances.count > 0 } do |contest_category|
    json.id contest_category.id.to_s
    json.name contest_category.name
  end
end
