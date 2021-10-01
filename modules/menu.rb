module Menu
    
# Promot Variable
prompt = TTY::Prompt.new

# Start Program Menu
    def welcome
        puts "Welcome!"
        # catpix ../storage/images/logo.jpg
    end


    def start_menu
        menu_options = %w(Login Register)
        puts "Menu"
        menu_options.each do |option|
            puts "- #{option}"
        end
        print "Please pick an option: " 
        menu_answer = gets.chomp.downcase!
        return menu_answer
    end


    # def start_menu 
    #     menu_options = %w(Login Register)
    #     prompt.multi_select("Menu", menu_options)
    # end    



end    

