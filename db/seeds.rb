# encoding: utf-8

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

bulgaria = Country.create(name: "Bulgarien", slug: "BG", country_code: "bg")
germany = Country.create(name: "Deutschland", slug: "D", country_code: "de")
denmark = Country.create(name: "Dänemark", slug: "DK", country_code: "dk")
estonia = Country.create(name: "Estland", slug: "EST", country_code: "ee")
finland = Country.create(name: "Finnland", slug: "FIN", country_code: "fi")
france = Country.create(name: "Frankreich", slug: "F", country_code: "fr")
ireland = Country.create(name: "Irland", slug: "IE", country_code: "ie")
norway = Country.create(name: "Norwegen", slug: "N", country_code: "no")
poland = Country.create(name: "Polen", slug: "PL", country_code: "pl")
romania = Country.create(name: "Rumänien", slug: "RO", country_code: "ro")
russia = Country.create(name: "Russland", slug: "RUS", country_code: "ru")
sweden = Country.create(name: "Schweden", slug: "S", country_code: "se")
switzerland = Country.create(name: "Schweiz", slug: "CH", country_code: "ch")
czech = Country.create(name: "Tschechien", slug: "CZ", country_code: "cz")
hungary = Country.create(name: "Ungarn", slug: "H", country_code: "hu")
uk = Country.create(name: "Vereinigtes Königreich (UK)", slug: "GB", country_code: "gb")

hosts = Host.create([
    { name: "DS Sofia", city: "Sofia", country_id: bulgaria.id },
    { name: "DS Kopenhagen", city: "Kopenhagen", country_id: denmark.id },
    { name: "DS Tallinn", city: "Tallinn", country_id: estonia.id },
    { name: "DS Helsinki", city: "Helsinki", country_id: finland.id },
    { name: "DS Paris", city: "Paris", country_id: france.id },
    { name: "DS Toulouse", city: "Toulouse", country_id: france.id },
    { name: "DS Dublin", city: "Dublin", country_id: ireland.id },
    { name: "DS Oslo", city: "Oslo", country_id: norway.id },
    { name: "DS Warschau", city: "Warschau", country_id: poland.id },
    { name: "DS Temeschwar", city: "Temeschwar", country_id: romania.id },
    { name: "DS Moskau", city: "Moskau", country_id: russia.id },
    { name: "DS Stockholm", city: "Stockholm", country_id: sweden.id },
    { name: "DS Genf", city: "Genf", country_id: switzerland.id },
    { name: "DS Prag", city: "Prag", country_id: czech.id },
    { name: "DS Budapest", city: "Budapest", country_id: hungary.id },
    { name: "DS London", city: "London", country_id: uk.id }
])

hosts.each do |host|
  Competition.create(
    {
      round_id: Round.first.id,
      host_id: host.id,
      begins: Date.new(2012, 12, 10),
      ends: Date.new(2013, 01, 14)
    }
  )
end

Category.create([
  {
    name: "\"Kinder musizieren\"",
    solo: true,
    ensemble: true,
    popular: false,
    slug: "KiMu",
    active: true
  },
  {
    name: "Violine solo",
    solo: true,
    ensemble: false,
    popular: false,
    slug: "Violine",
    active: true
  },
  {
    name: "Viola solo",
    solo: true,
    ensemble: false,
    popular: false,
    slug: "Viola",
    active: true
  },
  {
    name: "Violoncello solo",
    solo: true,
    ensemble: false,
    popular: false,
    slug: "Cello",
    active: true
  },
  {
    name: "Kontrabass solo",
    solo: true,
    ensemble: false,
    popular: false,
    slug: "Kontrabass",
    active: true
  },
  {
    name: "Akkordeon solo",
    solo: true,
    ensemble: false,
    popular: false,
    slug: "Akkordeon",
    active: true
  },
  {
    name: "Percussion solo",
    solo: true,
    ensemble: false,
    popular: false,
    slug: "Percussion",
    active: true
  },
  {
    name: "Mallets solo",
    solo: true,
    ensemble: false,
    popular: false,
    slug: "Mallets",
    active: true
  },
  {
    name: "Duo: Klavier & Blasinstrument",
    solo: false,
    ensemble: true,
    popular: false,
    slug: "Klavier+Bläser",
    active: true
  },
  {
    name: "Klavier-Kammermusik",
    solo: false,
    ensemble: true,
    popular: false,
    slug: "KlavierKammer",
    active: true
  },
  {
    name: "Vokal-Ensemble",
    solo: false,
    ensemble: true,
    popular: false,
    slug: "VokalEns",
    active: true
  },
  {
    name: "Zupf-Ensemble",
    solo: false,
    ensemble: true,
    popular: false,
    slug: "ZupfEns",
    active: true
  },
  {
    name: "Harfen-Ensemble",
    solo: false,
    ensemble: true,
    popular: false,
    slug: "HarfenEns",
    active: true
  },
  {
    name: "Besondere Ensemble: Alte Musik",
    solo: false,
    ensemble: true,
    popular: false,
    slug: "Duo Blä&Str",
    active: true
  },
  {
    name: "Gesang (Pop) solo",
    solo: true,
    ensemble: false,
    popular: true,
    slug: "PopGes",
    active: true
  },
  {
    name: "Gitarre (Pop) solo",
    solo: true,
    ensemble: false,
    popular: true,
    slug: "PopGit",
    active: true
  },
  {
    name: "E-Bass (Pop) solo",
    solo: true,
    ensemble: false,
    popular: true,
    slug: "PopBass",
    active: true
  },
  {
    name: "Drumset (Pop) solo",
    solo: true,
    ensemble: false,
    popular: true,
    slug: "PopDrums",
    active: true
  }
])

Epoch.create([
  { name: "Renaissance, Frühbarock", slug: "a" },
  { name: "Barock", slug: "b" },
  { name: "Frühklassik, Klassik", slug: "c" },
  { name: "Romantik, Impressionismus", slug: "d" },
  { name: "Klassische Moderne, Jazz, Pop", slug: "e" },
  { name: "Neue Musik", slug: "f" }
])

Role.create([
  { name: "Solist", slug: "S" },
  { name: "Begleiter", slug: "B" },
  { name: "Teil eines Ensembles", slug: "E" }
])

Instrument.create([
  { name: "Akkordeon" },
  { name: "Blockflöte" },
  { name: "Cembalo" },
  { name: "Drumset" },
  { name: "E-Bass" },
  { name: "E-Gitarre" },
  { name: "Englischhorn" },
  { name: "Euphonium" },
  { name: "Fagott" },
  { name: "Gesang" },
  { name: "Gitarre" },
  { name: "Harfe" },
  { name: "Horn" },
  { name: "Kantele" },
  { name: "Keyboard" },
  { name: "Klarinette" },
  { name: "Klavier" },
  { name: "Kontrabass" },
  { name: "Mallets" },
  { name: "Mandola" },
  { name: "Mandoline" },
  { name: "Oboe" },
  { name: "Orgel" },
  { name: "Percussion" },
  { name: "Posauna" },
  { name: "Querflöte" },
  { name: "Saxophon" },
  { name: "Trompete/Flügelhorn" },
  { name: "Tuba" },
  { name: "Viola" },
  { name: "Viola da Gamba" },
  { name: "Violine" },
  { name: "Violoncello" },
  { name: "Zither" }
])
