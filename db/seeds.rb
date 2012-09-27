# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

rounds = Round.create([
    { level: 1, name: "Regionalwettbewerb", slug: "RW" },
    { level: 2, name: "Landeswettbewerb",   slug: "LW" },
    { level: 3, name: "Bundeswettbewerb",   slug: "BW" }
])

finland = Country.create(name: "Finnland", slug: "FIN")
russia = Country.create(name: "Russland", slug: "RUS")

hosts = Host.create([
    { name: "DS Helsinki", country_id: finland.id },
    { name: "DS Moskau", country_id: russia.id }
])

competitions = Competition.create([
  {
    round_id: rounds.first.id,
    host_id: hosts.first.id,
    begins: Date.new(2013, 01, 15),
    ends: Date.new(2013, 01, 20)
  },
  {
    round_id: rounds.first.id,
    host_id: hosts.second.id,
    begins: Date.new(2013, 01, 10),
    ends: Date.new(2013, 01, 14)
  },
  {
    round_id: rounds.second.id,
    host_id: hosts.second.id,
    begins: Date.new(2013, 03, 06),
    ends: Date.new(2013, 03, 11)
  }
])