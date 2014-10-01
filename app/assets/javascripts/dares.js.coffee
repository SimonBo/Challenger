jQuery ->
  Stripe.setPublishableKey($('meta[name="stripe-key"]').attr('content'))
  bet.setupForm()

bet = 
	setupForm: ->
		console.log 'setup form'
		$('#new_dare').submit ->
			$('input[type=submit]').attr('disabled, true')
			if $('#card_number').length
				bet.processCard()
				false
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
