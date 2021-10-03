class Account

  # Class variable
  @@logged_in_user = nil

  # Registers new accounts
  def initialize(first_name, last_name, email, password)
      
      # Grabs and sorts data into variable
      @id = Utils.get_amount_of_accounts + 1
      @first_name = first_name.downcase
      @last_name = last_name.downcase
      @user_name = first_name.downcase + last_name.downcase + Utils.random_number(100).to_s
      @email = email.downcase
      @password = Base64.encode64(password)

      # Formats account information into a variable
      profile = {
          "id": @id,
          "first_name": @first_name,
          "last_name": @last_name,
          "user_name": @user_name,
          "email": @email,
          "password": @password
      }

      # Calls save_data method from Utils file to save the profile variable
      Utils.store_account(profile)
  end

  # Gets the currently logged in user info
  def self.get_logged_in_user
    return @@logged_in_user
  end

  # Authentications user
  def self.login(email_or_user, password)
      # Fetches all accounts stored in accounts.json via method
      accounts = Utils.fetch_accounts
      #Itterates over each json object until an email or username match is found which then matches with password provided to authenticate user
      accounts.each do |account|
      if (account['email'] == email_or_user or account['user_name'] == email_or_user) and account['password'] == Base64.encode64(password)
          # All informations linked to the accounts in accounts.json is stored within the class variable
          @@logged_in_user = account
          # Method returns true if authentication is a sucess and ends the loop
          return true
          end
      end
      # Returns false if auth failed (invalid information by user)
      return false
  end

end
