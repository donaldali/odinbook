$ ->
  $('#posts').on 'click', '.comment-focus', (event) ->
    event.preventDefault()
    $(this).closest('li').find("input[type='text']").focus()

  $('#posts').on 'focus', "li.post-container input[type='text']", ->
    $('li.post-container').removeClass('focus-post')
    $(this).closest('li').addClass('focus-post')
