# Update timetables of both changed dates
$('#<%= @new_day ? @new_day.to_s : "unscheduled" %> .draggable-performances').html(
  "<%= escape_javascript(render partial: 'draggable_performance',
       collection: @performances.on_date(@new_day).at_stage_venue(@new_stage_venue).browsing_order, as: :performance) %>"
)
$('#<%= @old_day ? @old_day.to_s : "unscheduled" %> .draggable-performances').html(
  "<%= escape_javascript(render partial: 'draggable_performance',
       collection: @performances.on_date(@old_day).at_stage_venue(@old_stage_venue).browsing_order, as: :performance) %>"
)

# Reset client-side performance filter to show all categories, unless unscheduled column was untouched
unless "<%= @new_day && @old_day %>"
  $("#performance_category_id").val("")
