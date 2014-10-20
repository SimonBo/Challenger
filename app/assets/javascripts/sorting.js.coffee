jQuery ->
	$(document).on 'click', '.sort_link', ->
		sort = $(this).attr('href')
		console.log sort
		if sort[sort.length - 1] == '1'
			console.log 'Ends with 1'
			$(this).attr('href', $(this).attr('href').substr(0, sort.length - 1))
			console.log 'Removed 1'
			$(this).next('.sort-arrow-up').removeClass('hidden')
			$(this).next('.sort-arrow-down').addClass('hidden')
		else
			console.log 'Doesnt end with 1'
			$(this).attr('href', $(this).attr('href') + 1)
			console.log 'Added 1'
			$(this).next('.sort-arrow-up').removeClass('hidden')
			console.log 'Showing up arrow'
			console.log $(this).next('.sort-arrow-up') 
			$(this).next('.sort-arrow-up').next('.sort-arrow-down').addClass('hidden')
			console.log 'Hiding down arrow'
			console.log $(this).next('.sort-arrow-down')
		$('#challenges').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(this).removeClass('animated rubberBand')
			);
