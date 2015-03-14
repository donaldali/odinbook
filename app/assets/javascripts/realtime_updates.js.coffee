jQuery ->
  dispatcher = new WebSocketRails 'localhost:3000/websocket'
  updates    = dispatcher.subscribe 'updates'

  dispatcher.bind 'new_notification', (data) ->
    $.getScript "/notifications/update_new"
    $('.notification-notice').fadeIn 'slow', ->
      setTimeout ( -> $('.notification-notice').fadeOut 'slow' ), 5000

  updates.bind 'update_like', (like_info) ->
    if $("##{ like_info.dom_id }").length
      $.post "/likes/create_destroy", options: like_info

  updates.bind 'add_comment', (comment_info) ->
    if $("##{ comment_info.dom_parent_id }").length
      $.getScript "/comments/add/#{comment_info.id}"

  updates.bind 'remove_comment', (comment_info) ->
    $("##{ comment_info.comment_dom_id }").fadeOut 'slow', ->
      $(this).remove()
      $(window).trigger('contentSizeReduced');

  updates.bind 'add_post', (post_info) ->
    if window.location.href.match /newsfeed|timeline/
      [action, user_id] = window.location.href.split("/")[-2..-1]
      $.post "/posts/add", id: post_info.id, post:  
                                               user_id: user_id, 
                                               action:  action

  updates.bind 'remove_post', (post_info) ->
    $("##{ post_info.post_dom_id }").fadeOut 'slow', ->
      $(this).remove()
      $(window).trigger('contentSizeReduced');
