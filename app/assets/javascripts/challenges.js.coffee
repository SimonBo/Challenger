NotificationPoller =
	poll: ->
		setTimeout @request, 30000

	cleanup: ->
		$('.user_panel.collapsed:has(a)').each ->
				$(this).removeClass('collapsed').collapse('show')
		$('.user_panel.collapse:not(:has(a))').each ->
			unless $(this).hasClass('collapsed') 
				$(this).addClass('collapsed').collapse('hide')

	request: ->
		$.getScript "/notifications"
		NotificationPoller.cleanup()
		NotificationPoller.poll()


jQuery ->
	notifications = $('#notifications')

	NotificationPoller.cleanup()

	if notifications.length > 0
		NotificationPoller.poll()
		



