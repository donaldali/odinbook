jQuery ->
  if $('body.users').length
    # Give comment input focus when Comment link is clicked
    $('#posts').on 'click', '.comment-focus', (event) ->
      event.preventDefault()
      $(this).closest('li').find("input[type='text']").focus()

    # Add a class to a post that has its input focused 
    # (Highlight the post with this class)
    $('#posts').on 'focus', "li.post-container input[type='text']", ->
      $('li.post-container').removeClass 'focus-post'
      $(this).closest('li').addClass 'focus-post'

    # Shrink post textarea and hide Post submit button on page load
    $('.post-textarea').height 45
    $('#post_content').css 'min-height', '35px'
    $('.post-submit').hide()
    $('.post-form').css 'margin-bottom', 10

    # Expand post textarea and show Post submit button on textarea focus
    $('#post_content').focus ->
      $('.post-textarea').height 73
      $('#post_content').css 'min-height', '73px'
      $('.post-submit').show()
      $('.post-form').css 'margin-bottom', 17

