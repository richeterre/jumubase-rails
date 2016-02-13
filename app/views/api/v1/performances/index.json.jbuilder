json.performances @performances do |performance|
  json.id performance.id
  json.stage_time performance.stage_time
  json.category_name performance.category.name
  json.age_group performance.age_group
  json.associated_host_name performance.associated_host.name
  json.associated_host_country performance.associated_host.country.country_code.upcase

  json.appearances performance.appearances.role_order do |appearance|
    json.participant_name appearance.participant.full_name
    json.instrument_name appearance.instrument.name
    json.role appearance.role.slug
  end
end
