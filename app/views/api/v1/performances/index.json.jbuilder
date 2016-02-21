json.array! @performances do |performance|
  json.id performance.id.to_s
  json.stage_time performance.stage_time
  json.category_name performance.category.name
  json.age_group performance.age_group
  if predecessor = performance.predecessor
    json.predecessor_host_name predecessor.associated_host.name
    json.predecessor_host_country predecessor.associated_host.country.country_code.upcase
  end

  json.appearances performance.appearances.role_order do |appearance|
    json.participant_name appearance.participant.full_name
    json.instrument_name appearance.instrument.name
    json.role appearance.role.slug
  end
end
