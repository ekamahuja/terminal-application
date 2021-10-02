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
  
    # Stores accounts into accounts.json file
    def Utils.store_account(account_data)
      file_path = "./storage/dataBase/accounts.json"
      file =  File.read(file_path)
      data = file == "" ? [] : JSON.parse(file)
      data << account_data
      File.write(file_path, JSON.pretty_generate(data))
    end

    def Utils.store_services(service_data)
        File.write("./storage/dataBase/services.json", JSON.pretty_generate(service_data))
    end
  
    # Fetches all registed accounts
    def Utils.fetch_accounts
      file_path = "./storage/dataBase/accounts.json"
  
      if File.exist?(file_path)
        file = File.read(file_path)
        accounts = JSON.parse(file)
        return accounts
      else
        file = File.new(file_path, 'w')
        data = []
        File.write(file_path, JSON.pretty_generate(data))
        file.close
        return data
       end
  
    end
  
    def Utils.get_amount_of_accounts
      return Utils.fetch_accounts.length
    end
  
  end