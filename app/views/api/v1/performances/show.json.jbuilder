json.stage_time @performance.stage_time
json.category_name @performance.category.name
json.age_group @performance.age_group

json.appearances @performance.appearances do |appearance|
  json.participant_name appearance.participant.full_name
  json.instrument_name appearance.instrument.name
  json.role appearance.role.slug
end

json.pieces @performance.pieces do |piece|
  json.title piece.title
  json.composer_name piece.composer_name
  json.duration piece.duration
  json.epoch piece.epoch.slug
end
