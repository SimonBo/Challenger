module LoginMacros
	def sign_in(user)
		user = create(:user)
		visit root_path
		click_link 'Sign in'
		fill_in 'Email', with: user.email
		fill_in 'Password', with: user.password
		click_button 'Log in'
	end
end