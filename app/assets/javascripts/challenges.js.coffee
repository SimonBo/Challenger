NotificationPoller =
  poll: ->
    setTimeout @request, 30000

  request: ->
    $.getScript "/notifications"
    console.log "Request"
    NotificationPoller.poll()

jQuery ->
  if $('#notifications').length > 0
    NotificationPoller.poll()