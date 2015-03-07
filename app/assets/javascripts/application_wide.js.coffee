$(window).scroll ->
  $('.header-holder').css('left', -$(this).scrollLeft() + "px")
