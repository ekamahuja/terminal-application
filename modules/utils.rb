module Utils

    def Utils.clear_console
        system("clear")
    end

    def Utils.wait(seconds_to_wait = 1)
        sleep seconds_to_wait
    end

    # Generates random number based on a maximum value provided
    def Utils.random_number(maximum_value)
        return rand(0...maximum_value)
    end

    # Stores accounts into .csv file
    def Utils.store_account(account_data)
        file = File.read("./storage/dataBase/accounts.json")
        data = file == "" ? [] : JSON.parse(file)
        data << account_data
        File.write('./storage/dataBase/accounts.json', JSON.dump(data))
    end


    def Utils.get_amount_of_accounts
        json = File.read("./storage/dataBase/accounts.json")
        accounts = JSON.parse(json)
        return accounts.length
    end

end