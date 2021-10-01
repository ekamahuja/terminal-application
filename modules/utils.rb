module Utils

    # Generates random number based on a maximum value provided
    def Utils.random_number(maximum_value)
        return rand(0...maximum_value)
    end

    # Stores accounts into .csv file
    def Utils.save_data(data)

        # CSV.open("./storage/dataBase/accounts.csv", "a") do |content|
        #     content << data
        # end

        # File.write('./storage/dataBase/accounts.json', JSON.dump(data))

        File.open("./storage/dataBase/accounts.json", "a") do |content|
            content << data    
        end
        
    end
end