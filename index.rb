# Import gems
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


# Import files
require_relative "modules/menu.rb"
require_relative "modules/account.rb"

# Import Modules
include Menu
include Account


# Variables for system



# Program

#Load Menu
Menu.welcome
Menu.start_menu

