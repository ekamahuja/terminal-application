class Account
    @@account_list = []

    attr_accessor :user_name, :first_name, :last_name, :email, :password

    def register_account(first_name, last_name, email, password)
        @user_name = first_name + last_name
        @first_name = first_name
        @last_name = last_name
        @email = email
        @password = password

        @@account_list.push(self)
    end

    def get_list
        return @@account_list
    end



end


ekam = Account.new.register_account("Ekam", "Ahuja", "EkamAhuja@Gmail.Com", "cumforme123")

puts ekam.first_name