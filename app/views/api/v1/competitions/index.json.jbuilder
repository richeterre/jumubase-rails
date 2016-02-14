json.array! @competitions do |competition|
  json.id competition.id.to_s
  json.name competition.name

  json.venues competition.venues do |venue|
    json.id venue.id.to_s
    json.name venue.name
  end
end
