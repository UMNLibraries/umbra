module Features
  module SignIn

    def sign_in(who = :user, trait = nil)
      user = who.instance_of?(User) ? who : create(who, trait)
      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'
    end

  end
end
