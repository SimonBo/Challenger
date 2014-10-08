NotificationPoller =
	poll: ->
		# old_nr_of_nots = notifications.text().length
		setTimeout @request, 30000

	request: ->
		$.getScript "/notifications"
		console.log "Request"
		NotificationPoller.poll()
		# new_nr_of_nots = notifications.text().length
		# if nr_of_nots > old_nr_of_nots
		# 	alert 'New notifications!'


jQuery ->
	notifications = $('#notifications')

	if notifications.length > 0
		NotificationPoller.poll()
		


