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
    json.participant_role JUMU_PARTICIPANT_ROLE_MAPPING[appearance.role.slug]
    json.instrument_name appearance.instrument.name
  end

  json.pieces performance.pieces do |piece|
    json.title piece.title
    json.composer_name piece.composer_name
    json.composer_born piece.composer_born
    json.composer_died piece.composer_died
    json.duration piece.duration
    json.epoch piece.epoch.slug
  end
end