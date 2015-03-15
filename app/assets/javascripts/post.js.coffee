jQuery ->
  if $('.feed-container').length
    # Display comment link
    $('.post-comment').show()

    # Limit comments displayed per post to 4 initially
    $('.comment-list').each (i, ele) ->
      $this = $(ele)
      if $this.hasClass 'new'
        id = $this.attr('id').split('-')[1]
        commentNum = $this.find('li').length

        if commentNum > 4
          left = commentNum - 4
          pluralize = if left > 1 then "comments" else "comment"
          html = """
                 <li class='more-comments'>
                   <a href='#'>View #{left} more #{pluralize}</a>
                 </li>
                 """
          $this.html($this.find('li')[-4..-1]).prepend html
               .find('a').attr 'id', id

        $this.removeClass 'new'
             .closest('li').find('.post-comment').show()


    # Get more comments for a post
    $('body').on 'click', '.more-comments a', (event) ->
      event.preventDefault()
      url = "/comments?post_id=#{$(this).attr('id')}"
      $.getScript url

    # Give comment input focus when Comment link is clicked
    $('body').on 'click', '.comment-focus', (event) ->
      event.preventDefault()
      $(this).closest('li').find("input[type='text']").focus()

    # Add a class to a post that has its input focused 
    # (Highlight the post with this class)
    $('body').on 'focus', "li.post-container input[type='text']", ->
      $('li.post-container').removeClass 'focus-post'
      $(this).closest('li').addClass 'focus-post'

    # Shrink post textarea and hide Post submit button on page load
    $('.post-textarea').addClass('shrink')
    $('#post_content').addClass('shrink')
    $('.post-submit').addClass('shrink')
    $('.post-form').addClass('shrink')

    # Expand post textarea and show Post submit button on textarea focus
    $('#post_content').focus ->
      $('.post-textarea').removeClass('shrink').addClass('expand')
      $('#post_content').removeClass('shrink').addClass('expand')
      $('.post-submit').removeClass('shrink').addClass('expand')
      $('.post-form').removeClass('shrink').addClass('expand')
