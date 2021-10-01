# Import gems
begin
    require "csv"
    require "tty-prompt"
    require "artii"
    require "base64"
    require "json"
rescue  LoadError
    puts "Please install all required gems via running 'bundle'"
    exit
end



# Import modules
require_relative "./modules/menu"
require_relative "./modules/utils"

# Import classes
require_relative "./classes/account"

# Include modules
include Menu
include Utils


# Variables for system


#Load Menu
Menu.welcome
# Menu.start_menu



user = Account.new("test", "test", "yrdy@gmail.com", "test123")
puts user