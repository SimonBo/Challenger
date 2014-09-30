NotificationPoller =
  poll: ->
    setTimeout @request, 5000

  request: ->
    $("#notifications").html "<%= j (render: 'users/user_notifications') %>"
    console.log "Request"
    NotificationPoller.poll()

jQuery ->
  if $('#notifications').length > 0
    NotificationPoller.poll()