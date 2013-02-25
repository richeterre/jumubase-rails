$ ->
  $(".modal").on 'shown', ->
    $(this).find("#appearance_points").focus()
