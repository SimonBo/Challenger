NotificationPoller =
	poll: ->
		setTimeout @request, 20000

	request: ->
		$.getScript "/notifications"
		console.log "Request"
		NotificationPoller.poll()



jQuery ->
	notifications = $('#notifications')

	if notifications.length > 0
		NotificationPoller.poll()
		


