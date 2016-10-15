$ ->
  dayOffset = 0

  draggable_attributes = {
    grid: [1, 15],
    opacity: 0.7,
    revert: 'invalid',
    snap: '.droppable-timetable',
    snapMode: 'inner',
    snapTolerance: 10,
    stack: '.draggable-performance'
  }

  $('.draggable-performance').draggable(draggable_attributes)

  $('.droppable-timetable').droppable({
    accept: '.draggable-performance',
    hoverClass: 'drophover',
    tolerance: 'pointer',
    over: (event, ui) ->
      ui.draggable.width($(this).width())
    ,
    drop: (event, ui) ->
      $.ajax({
        type: 'put',
        data: 'date=' + $(this).attr('id') + '&offset=' + Math.round(ui.position.top / 15) * 300 + '&stage_venue_id=' + $(this).attr("data-stage-venue-id"),
        dataType: 'script',
        context: $(this).closest('div'),
        complete: (request) ->
          $('.draggable-performance').draggable(draggable_attributes) # Re-enable dragging of performances
        ,
        url: '/jmd/performances/' + ui.draggable.attr('id') + '/reschedule'
      })
  })

  $('#unscheduled')
    .bind('dropactivate', (event, ui) ->
      if ui.draggable.closest('#unscheduled').length == 0
        $('#unschedule-text').fadeIn('fast')
    )
    .bind('dropdeactivate', (event, ui) ->
      $('#unschedule-text').fadeOut()
    )

  # Filtering performances client-side
  layoutUnscheduledPerformances = (performances) ->
    $('#unscheduled .draggable-performance').hide()
    performances.each (index) ->
      $(this).css("top", index * 60 + 120).show()

  # Browsing through days
  sliceDays = () ->
    $('.day-column').hide()
    $('.day-column').slice(dayOffset, dayOffset + 2).show()

  sliceDays() # Initial setup

  $('#earlier-button').click ->
    if (dayOffset > 0)
      dayOffset--
    sliceDays()

  $('#later-button').click ->
    if (dayOffset < ($('.day-column').length - 2))
      dayOffset++
    sliceDays()

  $('#performance_contest_category_id').change ->
    contestCategoryId = $(this).val()
    if contestCategoryId
      layoutUnscheduledPerformances(
        $('#unscheduled .draggable-performance').filter(() ->
          return $(this).attr("data-contest-category-id") == contestCategoryId
        )
      )
    else
      layoutUnscheduledPerformances $('#unscheduled .draggable-performance')
