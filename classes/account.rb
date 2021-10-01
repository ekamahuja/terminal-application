class Account
    attr_reader :id
    attr_accessor :first_name, :last_name, :user_name, :email, :password

    def initialize(first_name, last_name, email, password)
        @id = Account.get_id
        @first_name = first_name.downcase
        @last_name = last_name.downcase
        @user_name = first_name.downcase + last_name.downcase + Utils.random_number(100).to_s
        @email = email.downcase
        @password = Base64.encode64(password)

        profile = {
            "id": @id,
            "first_name": @first_name,
            "last_name": @last_name,
            "user_name": @user_name,
            "email": @email,
            "password": @password
        }

        Utils.save_data(profile)
    end



    def self.get_id
        id = Utils.get_amount_of_accounts + 1
        return id
    end



    
    # def self.data
    #     @@profile_data
    # end

end