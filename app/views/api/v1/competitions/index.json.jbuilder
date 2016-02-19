json.array! @competitions do |c|
  json.id c.id.to_s
  json.name c.name
  json.time_zone c.host.time_zone.name
  json.start_date c.begins.to_time(:utc) - c.host.time_zone.utc_offset
  json.end_date c.ends.to_time(:utc) - c.host.time_zone.utc_offset

  json.venues c.venues do |venue|
    json.id venue.id.to_s
    json.name venue.name
  end
end
