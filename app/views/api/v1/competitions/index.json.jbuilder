json.contests @competitions do |competition|
  json.name competition.name

  json.venues competition.venues do |venue|
    json.name venue.name
  end
end
