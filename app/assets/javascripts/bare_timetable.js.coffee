jumpToCurrent = ->
  timestamp = new Date().getTime() / 1000 | 0

  lastOfThePast = $(".performance-row").filter( ->
    $(this).attr("data-stage-time") < timestamp
  ).last()

  lastOfThePast.scrollTo() if lastOfThePast.length > 0

$ ->
  $.fn.scrollTo = ->
    $('html, body').animate({
      scrollTop: $(this).offset().top - $(".navbar-fixed-top").height() - 5 + 'px'
    }, 'slow')
    return this

  if (window.location.hash == "#autoreload")
    # window.setInterval ->
    #   document.location.reload(true)
    # , 10000

    window.setInterval ->
      jumpToCurrent()
    , 1000
