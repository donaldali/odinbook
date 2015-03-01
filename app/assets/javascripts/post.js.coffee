$ ->
  $('.comment-focus').click (event) -> 
    event.preventDefault()
    $(this).closest('li').find("input[type='text']").focus()

  $('li.post-container').find("input[type='text']").focus ->
    $('li.post-container').removeClass('focus-post')
    $(this).closest('li').addClass('focus-post')
