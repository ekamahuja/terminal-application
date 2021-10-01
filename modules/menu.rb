module Menu
    
# Promot Variable


    # Start Program Menu
    def welcome(name = "User")
        puts "Welcome, #{name}!\n\n"
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
    def start_menu 
        prompt = TTY::Prompt.new
        menu_options = %w(Login Register Exit)
        start_menu_choice = prompt.multi_select("Start Menu", menu_options)
    end    


    



end    

