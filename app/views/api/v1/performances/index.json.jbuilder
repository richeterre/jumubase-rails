json.array! @performances do |performance|
  json.id performance.id.to_s
  json.stageTime performance.stage_time
  json.categoryName performance.category.name
  json.ageGroup performance.age_group
  json.associatedHostName performance.associated_host.name
  json.associatedHostCountry performance.associated_host.country.country_code.upcase

  json.appearances performance.appearances.role_order do |appearance|
    json.participantName appearance.participant.full_name
    json.instrumentName appearance.instrument.name
    json.role appearance.role.slug
  end
end
