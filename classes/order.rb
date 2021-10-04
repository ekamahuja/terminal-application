class Order

  # Method to make new order in Order class
  def initialize(order_service, order_link, order_quantity)

    # Takes parms and sorts them into instant variables
    @order_service = order_service
    @order_link = order_link
    @order_quantity = order_quantity
    @order_data = {}

    # Calls method from API module to send a GET API request to place the order and saves resposne in a variable (order_response)
    order_response = Api.order_new(@order_service, @order_link, @order_quantity)
    
    # Once an order is placed, it sends another API request to get the status of the order
    order_status =  Order.check_status(JSON.parse(order_response[:response])['order'].to_s)
    
    # Take the information from order_response and order_status and sort it out in one json object under a instatn variable
    if order_response[:response_code] === 200
      @order_data =  {
          "user_id": Account.get_logged_in_user['id'],
          "order_id": Utils.get_amount_of_orders + 1.to_i,
          "provider_order_id": JSON.parse(order_response[:response])['order'],
          "service_id": @order_service.to_i,
          "service_name": Utils.get_services([@order_service])[0]['name'],
          "link": @order_link,
          "quantity": @order_quantity.to_i,
          "status": order_status['status'].downcase,
          "start_count": order_status['start_count'],
          "remains": order_status['remains'].to_i,
          "charge": order_status['charge'].to_i,
          "currency": order_status['currency'].downcase
      }

      # Calls method to save the order information into orders.json
      Utils.store_order(@order_data)
    
    # If response code is not 200, give error info (most likely this will never get called as the Api module handles any error that might occur)
    else
      utils.clear_console
      puts "Something has gone horriably wrong ! :/"
      puts "Error Info:\n Response from order call: #{order_response[:response]}\n Response from status call: #{order_status}"
      exit(1)
    end
  end

  # Returns the order_id of the succesfull order
  def to_s
    return (@order_data[:order_id]).to_s
  end

  # Method to view the order history of the user
  def self.view_history
    rows = []
    
    # Grabs all orders in accounts.json via a method from Utils module
    orders = Utils.fetch_orders
    
    # Gets the user_id of the logged in user
    user_id = Account.get_logged_in_user['id']

    # Each loop to itterate over orders 
    orders.each.with_index do |order, i|

      # To make sure the order only belongs to the user that is logged in
      if order['user_id'] === user_id

        # For orders that are uncompeleted 
        if ['pending', 'processing', 'progress', nil].include? order['status']
          
          # Send api request via class Method that checks and returns the status of the order id provided
          status = Order.check_status(order['provider_order_id'])

          # Updates the new information from the status check
          orders[i]['status'] = status['status'].downcase
          orders[i]['remains'] = status['remain']
          orders[i]['charge'] = status['charge']
          orders[i]['start_count'] = status['start_count']

          # saves the updated information from api request
          rows << [order['order_id'], order['service_name'], order['link'], "#{order['charge']} #{order['currency']}", order['start_count'], order['quantity'], status['status'], order['remains']]
        
        # Else manges orders that have already been marked as compeleted/canceled/refunded (there status wont change in api after those status have been set)
        else
          # saves the information without checking via API (from orders.json file)
          rows << [order['order_id'], order['service_name'], order['link'], "#{order['charge']} #{order['currency']}", order['start_count'], order['quantity'], order['status'].capitalize, order['remains']]
        end
      end
    end
  
    # Saves the updated information within orders.json (so once an order is compeleted/refunded/cancelded - there staus does not need to be re-checked next time)
    File.write(JSON.parse(File.read './storage/config/system_config.json')['ORDERS'], JSON.pretty_generate(orders))

    # Displays the table to the user 
    table = Terminal::Table.new :headings => ['Order ID', 'Service Name' , 'Link', 'Charge', 'Start Count', 'Quantity', 'Status', 'Remains'], :rows => rows
    puts table
  end

  # Method sends an API requst via Api module for order id that's provided and returns the response from api back
  def self.check_status(provider_order_id)
    return Api.check_status(provider_order_id)
  end

end

