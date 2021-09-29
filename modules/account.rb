begin
    require "csv"
    # require "colorize"
    require "tty-prompt"
    require "artii"
    require "base64"
    require 'securerandom'
    require "json"
rescue  LoadError
    puts "Please install all required gems via running 'bundle'"
    exit
end

module Account
    
    def register_account(first_name, last_name, email, password)
        begin
            user_profile = {
                "username": first_name + last_name + SecureRandom.random_number(100).to_s,
                "first_name": first_name,
                "last_name": last_name,
                "email": email,
                "password": Base64.encode64(password)
            }
            puts user_profile
        rescue => exception
            
        end
        
    end



end

include Account
Account.register_account("ekam", "ahuja", "ekamahujau@gmail.com", "test123")