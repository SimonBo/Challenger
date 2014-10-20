NotificationPoller =
	poll: ->
		setTimeout @request, 30000

	cleanup: ->
		$('.collapsed:has(a)').each ->
			# console.log 'Showing divs'
			$(this).removeClass('collapsed').collapse('show')
		$('.collapse:not(:has(a))').each ->
			unless $(this).hasClass('collapsed')
				# console.log 'Hiding divs'
				$(this).addClass('collapsed').collapse('hide')

	request: ->
		$.getScript "/notifications"
		NotificationPoller.cleanup()
		# console.log "Request"

		
		NotificationPoller.poll()


jQuery ->
	notifications = $('#notifications')

	NotificationPoller.cleanup()

	if notifications.length > 0
		NotificationPoller.poll()
		



