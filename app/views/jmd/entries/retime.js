// Update timetables of both changed dates
$('#<%= @new_day ? @new_day.to_s : "unscheduled" %> .draggable-entries').html(
	"<%= escape_javascript(render :partial => 'draggable_entry',
      :collection => @entries.on_date(@new_day).category_order, :as => :entry) %>"
);
$('#<%= @old_day ? @old_day.to_s : "unscheduled" %> .draggable-entries').html(
	"<%= escape_javascript(render :partial => 'draggable_entry',
      :collection => @entries.on_date(@old_day).category_order, :as => :entry) %>"
);