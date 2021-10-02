module Menu


    # Start Program Menu
    def Menu.welcome(name = "user")
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
                puts "Exiting Application..."
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
    def Menu.logged_in(user)
        prompt = TTY::Prompt.new
        menu_options = ["View all services", "Place Order", "Order History", "Check Order Status", "View Profile", "Edit Profile"]
        logged_menu_choice = prompt.select("Logged In User Menu\n", menu_options)
        
        case logged_menu_choice
            when "View all services"
                Service.view_all
            when "Place Order"
                Menu.start_new_order
            when "Order History"
                Order.view_history
            when "Check Order Status"
                Menu.order_status_check
            when "View Profile"
                Menu.view_profile(user)
            when "Edit Profile"
                Menu.edit_profile(user)
            else
                puts "Something went wrong!"
        end
    end
   
    # edits user profile
  def Menu.edit_profile(user)
    prompt = TTY::Prompt.new

    while true
        email = prompt.ask("What is your email?") do |q|
          q.validate(/\A\w+@\w+\.\w+\Z/, "Invalid email address -- Please enter a valid email address")
        end
        password_one = prompt.mask("Please enter a strong password: ")
        passsword_two = prompt.mask("Please confirm your password: ")
        mail_already_in_use = false

        if (password_one === passsword_two)
          password_confirmed = password_one
          accounts = Utils.fetch_accounts
          accounts.each do |account|
            if account['email'] == email
              puts "email already in use by some one else"
              mail_already_in_use = true
              break
            end
          end
          unless mail_already_in_use
              accounts = Utils.fetch_accounts
              accounts.each do |account|
                  if account['id'] == user['id']
                      account['email'] = email
                      account['password'] = Base64.encode64 password_confirmed
                  end
              end
              File.write(JSON.parse(File.read './storage/config/system_config.json')['ACCOUNTS'], JSON.pretty_generate(accounts))
              break
          end
        else
          puts "passwords do not match!"
        end
      end
    end

    # display user profile
    def Menu.view_profile(user)
        Utils.clear_console
        puts "Your Profile:"
        puts "Full Name: " + user['first_name'].capitalize + " " + user['last_name'].capitalize
        puts "Email: " + user['email'].capitalize
        puts "User Name: " + user['user_name'].capitalize
    end
end
