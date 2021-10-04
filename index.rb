# Import gems & give an error to the user if there are any missing gem(s)
begin
    require "tty-prompt"
    require "base64"
    require "json"
    require "terminal-table"
    require "httparty"
    require "dotenv"
rescue  LoadError
    puts "Please install all required gems by running 'bash start.sh'"
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
    # Load welcome menu and start menu
    if auth === !true
      if once_flag
        Menu.welcome
        once_flag = false
      end
        puts "\n"
        user = Menu.start_menu
        if user
            auth = user
        end
    else
      # Menu For when user logs in
      Utils.clear_console
      Menu.welcome(Account.get_logged_in_user['first_name'])
      Menu.logged_in
      break
    end
    # If something goes wrong, It lets the user know the error
    rescue => errorMessage
      puts "Something went wrong! =(\n Error #{errorMessage}"
    end
end

