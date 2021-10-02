module Utils

  # gets the config files
  @configs = JSON.parse(File.read './storage/config/system_config.json')
  
  # clears console contents
  def Utils.clear_console
    system("clear")
  end

  # make process wait 1 sec
  def Utils.wait(seconds_to_wait = 1)
    sleep seconds_to_wait
  end

  # Generates random number based on a maximum value provided
  def Utils.random_number(maximum_value)
    return rand(0...maximum_value)
  end

  # Stores accounts into accounts.json file
  def Utils.store_account(account_data)
    file_path = @configs['ACCOUNTS']
    file =  File.read(file_path)
    data = file == "" ? [] : JSON.parse(file)
    data << account_data
    File.write(file_path, JSON.pretty_generate(data))
  end

  # Stores fetched services into services.json as cache
  def Utils.store_services(service_data)
    file = File.open(@configs['SERVICES'], 'w')
    file << service_data
  end

  def Utils.store_order(order_data)
    puts order_data
    File.write("./storage/dataBase/orders.json", JSON.dump(order_data))
  end

  # Fetches all registred accounts
  def Utils.fetch_accounts
    file_path = @configs['ACCOUNTS']

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

  def Utils.fetch_orders
    file_path = @configs['ORDERS']

    if File.exist?(file_path)
      file = File.read(file_path)
      orders = JSON.parse(file)
      return orders
    else
      file = File.new(file_path, 'w')
      data = []
      File.write(file_path, JSON.pretty_generate(data))
      file.close
      return data
    end
  end

  # get all the services from store
  def Utils.get_services(ids_to_fetch)
    all_services = JSON.parse(File.read(@configs['SERVICES']))
    matching_services = []
    all_services.each do |service|
      if ids_to_fetch.include?(service['service'])
        matching_services.append service
      end
    end
    return matching_services
  end

  # gets the total accounts available in store
  def Utils.get_amount_of_accounts
    return Utils.fetch_accounts.length
  end
end


