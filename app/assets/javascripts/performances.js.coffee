window.Application ||= {}

Application.remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val("1")
  $(link).closest(".field-group").slideUp ->
    renumber()

Application.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  $(content.replace(regexp, new_id)).insertBefore(link).hide().slideDown ->
    renumber()

renumber = () ->
  # Renumber appearances
  $(".appearance:visible").each (index) ->
    $(".number", $(this)).text("Teilnehmer " + (index + 1))

  # Renumber pieces
  $(".piece:visible").each (index) ->
    $(".number", $(this)).text("Stück " + (index + 1))

$ ->
  renumber() # Renumber everything when page loads