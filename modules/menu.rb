module Menu

    # Get System config
    @configs = JSON.parse(File.read './storage/config/system_config.json')

    # Start Program Menu
  def Menu.welcome(name = "user")
    Utils.clear_console
    puts "Welcome, #{name.capitalize}!"
      # catpix ../storage/images/logo.jpg
  end

    # Start Menu
  def Menu.start_menu
    prompt = TTY::Prompt.new
    menu_options = %w(Login Register Exit)
    start_menu_choice = prompt.select("Start Menu", menu_options)

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

    # logs in a user
  def Menu.login_account
    prompt = TTY::Prompt.new
    email_or_user = prompt.ask("Please enter your email or username: ")
    password = prompt.mask("Please enter your password: ")
    Account.login(email_or_user, password)
  end

    # registers a user and store it in json store
  def Menu.register_account
    prompt = TTY::Prompt.new
    while true
      first_name = prompt.ask("Please enter your first name: ")
      if first_name
        break
      else
        puts "please enter valid first name"
      end
    end
    while true
      last_name = prompt.ask("Please enter your last name: ")
      if last_name
        break
      else
        puts "please enter valid last name"
      end
    end
    email = prompt.ask("What is your email?") do |q|
      q.validate(/\A\w+@\w+\.\w+\Z/, "Invalid email address -- Please enter a valid email address")
    end
    while true
      password_one = prompt.mask("Please enter a strong password: ")
      passsword_two = prompt.mask("Please confirm your password: ")
      if (password_one === passsword_two)
        password_confirmed = password_one
        accounts = Utils.fetch_accounts
        accounts.each do |account|
      if account['email'] == email
        puts "email already exists"
        return
      end
    end
        account = Account.new(first_name, last_name, email, password_confirmed)
        Utils.clear_console
        puts "Success! - Your account has been registed! :)"
        puts "Your username is #{account.user_name} - **Please take note**"
        return Account.login(email, passsword_two)
      else
        puts "Your passwords did not match, please re-enter your password"
      end
    end
  end

    # show the menu for authenticated user
  def Menu.logged_in
    prompt = TTY::Prompt.new
    Utils.clear_console
    menu_options = ["Place Order", "Order History", "Check Order Status", "View Profile", "Edit Profile", "Exit"]
    logged_menu_choice = prompt.select("Logged In User Menu\n", menu_options)

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
        else
          puts "Something went wrong!"
    end

  end

  # edits user profile
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

  def Menu.order_history
    prompt = TTY::Prompt.new
    Utils.clear_console
    puts "This may take a while to load depending on how many un-compeleted orders you have :)"
    Order.view_history
    prompt.keypress("Press Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end

  # display user profile
  def Menu.view_profile
    Utils.clear_console
    prompt = TTY::Prompt.new
    user = Account.get_logged_in_user
    puts "Full Name: #{user['first_name'].capitalize} #{user['last_name'].capitalize}\nUsername: #{user['user_name'].capitalize}\nEmail: #{user['email'].capitalize}"
    prompt.keypress("\nPress Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end


  # Place new order
  def Menu.start_new_order
    Utils.clear_console
    prompt = TTY::Prompt.new
    Api.fetch_services 
    service_list = Utils.get_services(@configs['MAIN_SERVICE_IDS'])
    service_name = []
    service_list.each do |service|
        service_name << "#{service['name']} |#{service['service']}|"
    end
    selected_service = prompt.select("Select a service you would like to: ", service_name)
    selected_service = Utils.get_services(["#{selected_service.split("|")[1]}"])
    selected_quantity = prompt.slider("Please choose how many you would like to order (quantity): ", min: selected_service[0]['min'].to_i, max: selected_service[0]['max'].to_i < 500 ? selected_service[0]['max'].to_i : 500, step: selected_service[0]['min'].to_i)
    selected_link = prompt.ask("Please enter a valiad link to the service you have selected: ") do |q|
        q.required true
        # q.validate /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/
    end
    puts "\nBy placing this order you agree to the terms and conditions of https://topnotchgrowth.com/terms"
    prompt.keypress("Press Enter to place your order", keys: [:return])
    Utils.clear_console
    order = Order.new(selected_service[0]['service'].to_s, selected_link.to_s, selected_quantity.to_s)
    puts "Your order has been placed! Your order ID is: #{order}"
    prompt.keypress("Press Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end

  # Check order status
  def Menu.order_status_check
    Utils.clear_console
    prompt = TTY::Prompt.new
    fail_choices = ["Re-try", "Main Menu"]
    user_order_id = prompt.ask("Please enter your Order ID: ") {  |q| q.in("0-1000000000000000000")}
    order_info = Utils.get_provider_id(user_order_id)

    if order_info == false || order_info['user_id'] != Account.get_logged_in_user['id']
      puts "Invalid Order ID or This Order does not belong to you!"
      user_choice = prompt.select("Please select to retry or return to menu", fail_choices)
      if user_choice === fail_choices[0]
        Menu.order_status_check
      else 
        Menu.logged_in
      end
    end

    status_info = Api.check_status(order_info['provider_order_id'].to_s)

    if status_info['status']
      puts "Order Status: #{status_info['status']}\nStart Count: #{status_info['start_count']}\nRemains: #{status_info['remains']}\nCost: #{status_info['charge']} #{status_info['currency']}\n"
    else
      case status_info['error']
        when "Incorrect order ID" 
          puts "Please Enter a valid Order ID"
          user_choice = prompt.select("Please select to retry or return to menu", fail_choices)
          if user_choice === fail_choices[0]
            Menu.order_status_check
          else 
            Menu.logged_in
          end
        else
          puts "Error Occured!\n Error: #{status_info['error']}"
        end
    end
    prompt.keypress("Press Enter to return to main menu", keys: [:return])
    Menu.logged_in
  end

end

