jumpToCurrent = ->
  timestamp = new Date().getTime() / 1000 | 0

  lastOfThePast = $(".performance-row").filter( ->
    $(this).attr("data-stage-time") < timestamp
  ).last()

  if lastOfThePast.length > 0
    scrollAmount = lastOfThePast.offset().top - $(".navbar-fixed-top").height() - 5
  else
    scrollAmount = 0

  console.log "Scroll amount: " + scrollAmount

  $('html, body').scrollTop(scrollAmount)

$ ->
  if (window.location.hash == "#autoreload")
    window.setInterval ->
      document.location.reload(true)
    , 3000000 # every 5 minutes

    window.setInterval ->
      jumpToCurrent()
    , 2000 # every 2 seconds
