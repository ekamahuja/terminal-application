module Menu

    # Promot Variable
    
    
        # Start Program Menu
        def Menu.welcome(name = "user")
            puts "Welcome, #{name.capitalize}!"
            # catpix ../storage/images/logo.jpg
        end
    
        # def start_menu
        #     menu_options = %w(Login Register)
        #     puts "Menu"
        #     menu_options.each do |option|
        #         puts "- #{option}"
        #     end
        #     print "Please pick an option: "
        #     menu_answer = gets.chomp.downcase!
        #     return menu_answer
        # end
    
    
        # Start Menu
        def Menu.start_menu
            prompt = TTY::Prompt.new
            menu_options = %w(Login Register Exit)
            start_menu_choice = prompt.select("Start Menu", menu_options)
            case start_menu_choice
                when "Login"
                    Utils.clear_console
                    if not Menu.login_account
                        puts "Invalid login credentials"
                    else
                        return true
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
    
    
        def Menu.login_account
            prompt = TTY::Prompt.new
            email_or_user = prompt.ask("Please enter your email or username: ")
            password = prompt.mask("Please enter your password: ")
            Account.login(email_or_user, password)
        end
    
    
        def Menu.register_account
            prompt = TTY::Prompt.new
            first_name = prompt.ask("Please enter your first name: ")
            last_name = prompt.ask("Please enter your last name: ")
            email = prompt.ask("What is your email?") do |q|
                q.validate(/\A\w+@\w+\.\w+\Z/, "Invalid email address -- Please enter a valid email address")
            end
            while true
                password_one = prompt.mask("Please enter a strong password: ")
                passsword_two = prompt.mask("Please confirm your password: ")
                if (password_one === passsword_two)
                    password_confirmed = password_one
                    account = Account.new(first_name, last_name, email, password_confirmed)
                    Utils.clear_console
                    puts "Success! - Your account has been registed! :)"
                    puts "Your username is #{account.user_name} - **Please take note**"
                    break
                else
                    puts "Your passwords did not match, please re-enter your password"
                end
            end
            # puts "#{first_name} -- #{last_name} -- #{email} -- #{password_confirmed}"
        end
    
    end
    
    