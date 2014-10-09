NotificationPoller =
	poll: ->
		setTimeout @request, 30000

	request: ->
		$.getScript "/notifications"
		console.log "Request"
		NotificationPoller.poll()



jQuery ->
	notifications = $('#notifications')

	if notifications.length > 0
		NotificationPoller.poll()
		


