# Update timetables of both changed dates
$('#<%= @new_day ? @new_day.to_s : "unscheduled" %> .draggable-performances').html(
  "<%= escape_javascript(render partial: 'draggable_performance',
       collection: @performances.on_date(@new_day).browsing_order, as: :performance) %>"
)
$('#<%= @old_day ? @old_day.to_s : "unscheduled" %> .draggable-performances').html(
  "<%= escape_javascript(render partial: 'draggable_performance',
       collection: @performances.on_date(@old_day).browsing_order, as: :performance) %>"
)
