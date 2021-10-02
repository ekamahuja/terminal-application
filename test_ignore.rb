# Import gems & give an error to the user if there are any missing gem(s)
begin
    require "tty-prompt"
    require "base64"
    require "json"
    require "terminal-table"
    require "httparty"
    require "dotenv"
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

configs = JSON.parse(File.read './storage/config/system_config.json')

# Account.login('test', 'pass"')
# Order.new("374", "https://test.com", "10")
Menu.start_new_order
# Api.fetch_services
# puts Utils.get_services(configs['MAIN_SERVICE_IDS'])
# Utils.get_services(231)
