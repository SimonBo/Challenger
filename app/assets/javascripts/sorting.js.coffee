jQuery ->
	$(document).on 'click', '.sort_link', ->
		# $('.challenge-name').addClass('animated rubberBand')
		sort = $(this).attr('href')
		console.log sort
		if sort[sort.length - 1] == '1'
			console.log 'Ends with 1'
			$(this).attr('href', $(this).attr('href').substr(0, sort.length - 1))
			console.log 'Removed 1'
		else
			console.log 'Doesnt end with 1'
			$(this).attr('href', $(this).attr('href') + 1)
			console.log 'Added 1'
		# $('#challenges').removeClass('animated rubberBand')
		$('#challenges').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(this).removeClass('animated rubberBand')
			);
