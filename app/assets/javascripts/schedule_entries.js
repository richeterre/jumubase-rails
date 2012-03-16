$(document).ready(function() {
	
	var dayOffset = 0;
	
	var draggable_attributes = {
    containment: '#draggable-container',
    grid: [1, 15],
    opacity: 0.7,
    revert: 'invalid',
    snap: '.droppable-timetable',
    snapMode: 'inner',
    snapTolerance: 10,
		stack: '.draggable-entry'
  };

  $('.draggable-entry').draggable(draggable_attributes);
  
  $('.droppable-timetable').droppable({
    accept: '.draggable-entry',
    hoverClass: 'drophover',
    tolerance: 'fit',
		drop: function(event, ui) {
      $.ajax({
        type: 'put', 
        data: 'entry_id=' + ui.draggable.attr('id')
              + '&date=' + $(this).attr('id')
              + '&offset=' + Math.round(ui.position.top / 15) * 300,
        dataType: 'script',
        context: $(this).closest('div'),
        complete: function(request) {
        	$('.draggable-entry').draggable('destroy').draggable(draggable_attributes);
        },
        url: '/jmd/entries/retime'
      });
    }
  });

	$('#unscheduled')
		.bind('dropactivate', function(event, ui) {
			if (ui.draggable.closest('#unscheduled').length == 0) {
				$('#unschedule-text').fadeIn('fast');
			}
		})
		.bind('dropdeactivate', function(event, ui) {
			$('#unschedule-text').fadeOut();
		});
	
	// Browsing through days
	function sliceDays() {
		$('.day-column').hide();
		$('.day-column').slice(dayOffset, dayOffset + 2).show();
	}
	
	sliceDays(); // Initial setup
	
	$('#earlier-button').click(function() {
		if (dayOffset > 0) dayOffset--;
		sliceDays();
	});
	
	$('#later-button').click(function() {
		if (dayOffset < ($('.day-column').length - 2)) dayOffset++;
		sliceDays();
	});
	
	
	
});