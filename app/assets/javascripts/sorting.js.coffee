jQuery ->
	$(document).on 'click', '.sort_link', ->
		sort = $(this).attr('href')
		if sort[sort.length - 1] == '1'
			self = $(this)
			self.attr('href', self.attr('href').substr(0, sort.length - 1))
			self.next('.sort-arrow-up').addClass('hidden')
			self.next('.sort-arrow-up').next('.sort-arrow-down').removeClass('hidden')
		else
			self = $(this)
			self.attr('href', self.attr('href') + 1)
			self.next('.sort-arrow-up').removeClass('hidden')
			self.next('.sort-arrow-up').next('.sort-arrow-down').addClass('hidden')
		$('#challenges').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
			$(this).removeClass('animated rubberBand')
			);
