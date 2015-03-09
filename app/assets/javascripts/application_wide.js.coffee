$(window).scroll ->
  $('.header-holder').css('left', -$(this).scrollLeft() + "px")

jQuery ->
  $.rails.allowAction = (link) ->
    return true unless link.attr 'data-confirm'
    $.rails.showConfirmDialog link
    false

  $.rails.confirmed = (link) ->
    link.removeAttr 'data-confirm' 
    link.trigger 'click.rails'

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
           <div id="dialog-confirm" title="WARNING!">
             <p>#{message}</p>
           </div>
           """
    $(html).dialog
      resizable: false
      modal: true
      width: 350
      buttons: 
        "I'm Sure": ->
          $.rails.confirmed link
          $(this).dialog "close"
        Cancel: -> 
          $(this).dialog "close"
