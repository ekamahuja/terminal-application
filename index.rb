# Import gems & give an error to the user if there are any missing gem(s)
begin
    require "csv"
    require "tty-prompt"
    require "artii"
    require "base64"
    require "json"
rescue  LoadError
    puts "Please install all required gems via running 'bundle install'"
    exit(1)
end

# Import modules
require_relative "./modules/menu"
require_relative "./modules/utils"

# Import classes
require_relative "./classes/account"
require_relative "./classes/order"

# Include modules
include Menu
include Utils


# Variables for system
app = true

#Load Menu
while app === true 
    begin
        Menu.welcome
        Utils.wait(1)
        puts "\n"
        Menu.start_menu
    rescue => errorMessage
        puts errorMessage.uppercase
    end
end




# user = Account.new("firstone", "LASTasttest", "yrdy@gmail.com", "test123")
# Utils.get_accounts