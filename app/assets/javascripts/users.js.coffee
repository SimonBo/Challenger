jQuery ->
	if $('#accordion').length > 0  
		$('.collapse:not(:has(a))').each ->
			$(this).collapse('toggle')