class Account
    
    # Attr Variables
    attr_reader :id, :first_name, :last_name, :user_name
    attr_accessor :email, :password

    # Registers new accounts
    def initialize(first_name, last_name, email, password)

        # Grabs and sorts data into variable
        @id = Account.get_id
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


    # Grabs the amount of current accounts registed, and add +1 to make an unique ID for a new account
    def self.get_id
        return Utils.get_amount_of_accounts + 1
    end


    # Authentications user
    def self.login(email_or_user, password)
        # email_or_user.downcase!
        accounts = Utils.fetch_accounts
        puts accounts
    end



    
    # def self.data
    #     @@profile_data
    # end

end