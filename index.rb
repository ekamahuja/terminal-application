# Import gems & give an error to the user if there are any missing gem(s)
begin
    require "tty-prompt"
    require "base64"
    require "json"
    require "terminal-table"
    require "httparty"
rescue  LoadError
    puts "Please install all required gems via running 'bundle install'"
    exit(1)
end

# Import modules
require_relative "./modules/menu"
require_relative "./modules/utils"
require_relative "./modules/api"

# Import classes
require_relative "./classes/account"
require_relative "./classes/order"

# Include modules
include Menu
include Utils
include Api



# Variables for system
app = true
auth = false
once_flag = true
#Load Menu
while app === true
    begin
    if auth === !true
      if once_flag
        Menu.welcome
        once_flag = false
      end
        # Utils.wait(1)
        puts "\n"
        user = Menu.start_menu
        if user
            auth = user
        end
    else
      Menu.welcome(auth['first_name'])
      break
        # Menu for when authenticated
    end
    rescue => errorMessage
        puts errorMessage
    end
end


# Account.login('test', 'pass"')
# Order.new("374", "https://test.com", "10")
Api.fetch_services