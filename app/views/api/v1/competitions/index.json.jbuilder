json.contests @competitions do |competition|
  json.id competition.id
  json.name competition.name

  json.venues competition.venues do |venue|
    json.id venue.id
    json.name venue.name
  end
end
