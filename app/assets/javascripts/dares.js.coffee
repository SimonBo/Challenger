jQuery ->
	enable_bet_box = $('#dare_with_bet')
	betting_fields = $('.betting_fields :input')

	betting_fields.prop('disabled', true)

	enable_bet_box.change ->
		if enable_bet_box.prop('checked') 
			betting_fields.prop('disabled', false)
		else
			betting_fields.prop('disabled', true)


	


  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  bet.setupForm()

bet = 
	
	setupForm: ->
		console.log 'setup form'
		$('#new_dare').submit ->
			console.log 'submitting'
			if $('.betting_fields :input').prop('disabled', false)
				$('input[type=submit]').attr('disabled, true')
				if $('#card_number').length
					console.log 'gonna process card'
					bet.processCard()
					false
				else
					console.log 'not processing card'
					true
			else
				true

	processCard: ->
		card =
			number: $('#card_number').val()
			cvc: $('#card_code').val()
			expMonth: $('#card_month').val()
			expYear: $('#card_year').val()
		console.log 'creating token'
		Stripe.createToken(card, bet.handleStripeResponse)

	handleStripeResponse: (status, response) ->
		console.log 'Handling response'
		console.log response.id
		if status == 200
			console.log 'success'
			$('#stripe_card_token').val(response.id)
			$('#new_dare')[0].submit()
		else
			console.log 'fail'
			$('#stripe_error').text(response.error.message)
			$('input[type=submit').attr('disabled', false)
