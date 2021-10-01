class Account

    attr_reader :first_name, :last_name, :user_name, :email, :password
    @@profile_data = []

    def initialize(first_name, last_name, email, password)
        @first_name = first_name.downcase!
        @last_name = last_name.downcase!
        @user_name = first_name + last_name + Utils.random_number(100).to_s
        @email = email.downcase!
        @password = Base64.encode64(password)

        profile = @first_name

        @@profile_data << profile
        Utils.save_data(@@profile_data)
    end


    
    # def self.data
    #     @@profile_data
    # end

end