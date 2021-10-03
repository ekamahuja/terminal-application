module Menu

  # Get System config
  @configs = JSON.parse(File.read './storage/config/system_config.json')

  # Start Program Menu
  def Menu.welcome(name = "user")
    Utils.clear_console
    puts "Welcome, #{name.capitalize}!"
  end

  # Start Menu
  def Menu.start_menu
    # Prompts User with options when the script starts (login/register/exit) using tty-prompt
    prompt = TTY::Prompt.new
    start_menu_choice = prompt.select("Start Menu", %w(Login Register Exit))

  # Depending on what the user chooses, to puts information and call the methods to choose there selection
  case start_menu_choice
    when "Login"
      Utils.clear_console
      user = Menu.login_account
      if not user
        puts "Invalid login credentials"
      else
        return user
      end
    when "Register"
      Utils.clear_console
      Menu.register_account
    when "Exit"
      Utils.clear_console
      puts "Exiting Application... GoodBye! =)"
      exit(0)
    else
      Utils.clear_console
      puts "Something went horribly wrong :/"
      puts "Error Information: Invalid choice selected in menu module  - start_menu method"
      exit(1)
    end
  end

  # Method to get users login information and then log them in
  def Menu.login_account
    # Gets user information
    prompt = TTY::Prompt.new
    email_or_user = prompt.ask("Please enter your email or username: ")
    password = prompt.mask("Please enter your password: ")

    # Calls a method in a class to check authenticate them after validating their detatils
    Account.login(email_or_user, password)
  end

  # Registers a brand new account
  def Menu.register_account
    prompt = TTY::Prompt.new
    
    # Gets the users information such as first name, last name, email, password
    # While solves the problem of re-asking hte user information until they have entered a valid first name and last name

    # Gets a valid first name from the user (loops while entered a valid one)
    while true
      first_name = prompt.ask("Please enter your first name: ")
      if first_name
        break
      else
        puts "Please enter a valid first name!"
      end
    end

    # Gets a valid last name from the user (loops while entered a valid one)
    while true
      last_name = prompt.ask("Please enter your last name: ")
      if last_name
        break
      else
        puts "Pleae enter a valid name"
      end
    end

    # Gets a valid email from user
    email = prompt.ask("What is your email?") do |q|
      q.validate(/\A\w+@\w+\.\w+\Z/, "Invalid email address -- Please enter a valid email address")
    end

    # Keeps looping until the user enters matching password prompts
    while true
      password_one = prompt.mask("Please enter a strong password: ")
      passsword_two = prompt.mask("Please confirm your password: ")

      # If password one and password_two matches
      if (password_one === passsword_two)
        password_confirmed = password_one
        
        #Fetchs all stored accounts by calling the method from Utils module
        accounts = Utils.fetch_accounts
        
        #Itterates over all accounts into account and returns a error the user if the email is already registed
        accounts.each do |account|
          if account['email'] == email
            puts "The inputed email is already registed!"
            return
          end
        end

        # Calls a initialize methond in class Account to create a new account and saves response into a variable called account
        account = Account.new(first_name, last_name, email, password_confirmed)

        # Clears console by calling a method from Utils module
        Utils.clear_console
        
        # Gives user successfull message and provides them with there randomly generated username
        puts "Success! - Your account has been registed! :)"
        puts "Your username is #{account.user_name} - **Please take note**"

        # Calls the login method log the user in and also return the response from Account.login
        return Account.login(email, passsword_two)

      # If password_one and password_two do not match to present an error the user to re-enter there detatils
      else
        puts "Your passwords did not match, please re-enter your password"
      end
    end
  end

  # Menu for authenticated users
  def Menu.logged_in
    # Clears console by calling a method from Utils module
    Utils.clear_console

    # Prompts user with the options
    prompt = TTY::Prompt.new
    menu_options = ["Place Order", "Order History", "Check Order Status", "View Profile", "Edit Profile", "Exit"]
    logged_menu_choice = prompt.select("Logged In User Menu\n", menu_options)

    # Switch statment to call a method depending on what the user choosed
    case logged_menu_choice
      when "Place Order"
        Menu.start_new_order
      when "Order History"
        Menu.order_history
      when "Check Order Status"
        Menu.order_status_check
      when "View Profile"
        Menu.view_profile
      when "Edit Profile"
        Menu.edit_profile
      when "Exit"
        Utils.clear_console
        puts "Exiting Application... GoodBye! =)"
        exit(0)
      # Else statment to issue an error and exit (will most likely never get called as everything is handeled here automatically)
      else
        puts "Something went wrong!\n Choice: #{logged_menu_choice}"
        exit(1)
    end

  end

  # Method for editing profile
  def Menu.edit_profile
    Utils.clear_console
    prompt = TTY::Prompt.new
    menu_options = ["Change E-mail", "Change Password", "Main Menu"]
    change_menu_options = prompt.select("Profile Edit Menu:\n", menu_options)
    accounts = Utils.fetch_accounts
    user = Account.get_logged_in_user

    case change_menu_options
      when "Change E-mail"
        while true
          Utils.clear_console
          email = prompt.ask("Please enter your new email: ") do |q|
            q.validate(/\A\w+@\w+\.\w+\Z/, "Invalid email address -- Please enter a valid email address")
          end
          mail_already_in_use = false
          accounts.each do |account|
            if account['email'] == email
              puts "This email already exists by another user or this is already your current email!"
              mail_already_in_use = true
              break
            end
          end
          unless mail_already_in_use
            accounts.each do |account|
              if account['id'] == user['id']
                account['email'] = email
              end
            end
            File.write(JSON.parse(File.read './storage/config/system_config.json')['ACCOUNTS'], JSON.pretty_generate(accounts))
            puts "Email Updated!"
            prompt.keypress("Press Enter to return to main menu", keys: [:return])
            Menu.logged_in
            break
          end
        end
      when "Change Password"
        Utils.clear_console
        while true
          current_password = prompt.mask("Please enter current password: ") do |q|
            q.required true
          end
          password_one = prompt.mask("Please enter a strong password: ") do |q|
            q.required true
          end
          passsword_two = prompt.mask("Please confirm your password: ") do |q|
            q.required true
          end

          current_password = Base64.encode64(current_password)
          if (current_password != user['password'])
            puts "Your current password is incorrect! :("
          elsif (password_one != passsword_two)
            puts "Your new passwords do not match!"
          else
            accounts.each do |account|
              if account['id'] == user['id']
                account['password'] = Base64.encode64 password_one
              end
            end
            File.write(JSON.parse(File.read './storage/config/system_config.json')['ACCOUNTS'], JSON.pretty_generate(accounts))
            Utils.clear_console
            puts "Your password has been updated!"
            prompt.keypress("Press Enter to return to main menu", keys: [:return])
            Menu.logged_in
            break
          end
        end
      when "Main Menu"
        Menu.logged_in
      else
        puts "something went wrong!"
    end
  end

  # Method for viewing order history
  def Menu.order_history
    # Clears console via Utils module
    Utils.clear_console
    
    # Warrning to the user about loading time
    puts "This may take a while to load depending on how many un-compeleted orders you have :)"
    
    # Calls a method in class Order to show a table of order history
    Order.view_history

    # Return to menu system
    prompt = TTY::Prompt.new
    prompt.keypress("Press Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end

  # Method for viewing user profile
  def Menu.view_profile
    # Clears console via Utils module
    Utils.clear_console
    
    # Calls class method from account.rb to get the information about the logged in user
    user = Account.get_logged_in_user

    # Prints the user detatils to the console
    puts "Full Name: #{user['first_name'].capitalize} #{user['last_name'].capitalize}\nUsername: #{user['user_name'].capitalize}\nEmail: #{user['email'].capitalize}"
    
    # Return to menu system
    prompt = TTY::Prompt.new
    prompt.keypress("\nPress Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end


  # Place new order
  def Menu.start_new_order
    # Clears console via Utils module
    Utils.clear_console

    # Variable for tty-table gem
    prompt = TTY::Prompt.new

    # calls a method Api module (api.rb) to fetch the most update to date data via api and then store it in services.json for further use
    Api.fetch_services 

    # Stores only the reccomend services data in a variable (./storage/config/system_config.json) (calls a function from Utils to grab the data of only specified services)
    service_list = Utils.get_services(@configs['MAIN_SERVICE_IDS'])

    # Using each do to only store the name and service id of the service in a format to display it to the user (we also need to store the id in the name to regrab all the service information later)
    service_name = []
    service_list.each do |service|
        service_name << "#{service['name']} |#{service['service']}|"
    end

    # Prompts the user for their selection of service they would like to order
    selected_service = prompt.select("Select a service you would like to: ", service_name)

    # Uses .split to grab the id of the service and then to call a Utils.get_services method to only get the data of specified services back
    selected_service = Utils.get_services(["#{selected_service.split("|")[1]}"])

    # Prompts user for quantity via a slider (min and max are grabbed from services.json data (which is refreshed everytime a Menu.start_new_order is called) however if the value is above 500 (max value) then it justs the max value to 500 for friendly user interface)
    selected_quantity = prompt.slider("Please choose how many you would like to order (quantity): ", min: selected_service[0]['min'].to_i, max: selected_service[0]['max'].to_i < 500 ? selected_service[0]['max'].to_i : 500, step: selected_service[0]['min'].to_i)

    # Prompts user for the link
    selected_link = prompt.ask("Please enter a valiad link to the service you have selected: ") do |q|
        q.required true
    end

    # Confirms the user would let to place the order
    puts "\nBy placing this order you agree to the terms and conditions of https://topnotchgrowth.com/terms"
    prompt.keypress("Press Enter to place your order", keys: [:return])
    
    # Clears console via Utils method
    Utils.clear_console

    # Places the new order via Order.new (which call an api request from api.rb), the order id is stored in order variable
    order = Order.new(selected_service[0]['service'].to_s, selected_link.to_s, selected_quantity.to_s)

    # Success message to the user with there order id
    puts "Your order has been placed! Your order ID is: #{order}"
    
    # Return to menu system
    prompt.keypress("Press Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end

  # Check order status
  def Menu.order_status_check
    
    # Clears console via module Utils
    Utils.clear_console
    # Prompt for tty-prompt gem
    prompt = TTY::Prompt.new

    # Variable to store options if the user enters invalid order id
    fail_choices = ["Re-try", "Main Menu"]
    
    # Prompts user to the order id for the order's status they would like to check
    user_order_id = prompt.ask("Please enter your Order ID: ") {  |q| q.in("0-1000000000000000000")}

    # Calls a method from Utils module to get the provider_order_id back so it can be used via sending the api request to check the status
    order_info = Utils.get_provider_id(user_order_id)

    # If order_info does return false (false if order id does not exisit) or the order_info belongs to another user, to give an error to the user about invalid order id
    if order_info == false || order_info['user_id'] != Account.get_logged_in_user['id']
      puts "Invalid Order ID or This Order does not belong to you!"

      # Retry/Return to menu system
      user_choice = prompt.select("Please select to retry or return to menu", fail_choices)
      if user_choice === fail_choices[0]
        Menu.order_status_check
      else 
        Menu.logged_in
      end
    end

    # If order is valiad and the order is owned by the logged in user, it will send an API request to get the status
    status_info = Api.check_status(order_info['provider_order_id'].to_s)

    # If the api responds with the status key (success response)
    if status_info['status']
      # print order status information to the console
      puts "Order Status: #{status_info['status']}\nStart Count: #{status_info['start_count']}\nRemains: #{status_info['remains']}\nCost: #{status_info['charge']} #{status_info['currency']}\n"
    
    # If an error occurs (not valiad response)
    else
      
      # Case statement to detect what kind of error
      case status_info['error']
        # If order is invalid on api end
        when "Incorrect order ID" 

          # Prints the error to the user
          puts "Please Enter a valid Order ID"

          # Retry/Return to menu system
          user_choice = prompt.select("Please select to retry or return to menu", fail_choices)
          if user_choice === fail_choices[0]
            Menu.order_status_check
          else 
            Menu.logged_in
          end
        
        # If it is a unkown error, it will let the user know an error occured and give information about the error
        else
          puts "Error Occured!\n Error: #{status_info['error']}"
        end
    end

    # Return to menu system
    prompt.keypress("Press Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end

end

