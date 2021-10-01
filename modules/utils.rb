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
            content << data.to_json    
        end

    end


    def Utils.get_amount_of_accounts
        json = File.read("./storage/dataBase/accounts.json")
        accounts = JSON.parse(json)
        puts "Amount Of Accounts #{accounts}"
        return accounts.length
    end    
end