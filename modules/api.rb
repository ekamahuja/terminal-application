module Api

  # Loading Config/ENV
  @configs = JSON.parse(File.read './storage/config/system_config.json')
  Dotenv.load('./.env')

  # Setting File Variables
  @api_key = ENV['API_KEY']

  # Sends API request to place an order
  def Api.order_new(order_service, order_link, order_quantity)
    begin
      #GET request
      response = HTTParty.get("#{@configs['API_BASE_URL']}?key=#{@api_key}&action=add&service=#{order_service}&link=#{order_link}&quantity=#{order_quantity}")
      if JSON.parse(response.body).instance_of? Hash and JSON.parse(response.body).key? 'error'
        raise APIError
      end
      # Stores response and response code from the API into a variable
      new_order_response = {
          "response": response.body,
          "response_code": response.code
      }

      # Returns the variable with stored response information
      return new_order_response
  rescue APIError
    return nil
    end
  end

  # API request to fetch all services avaliable with their detatil 
  def Api.fetch_services
    begin  
      # GET request
      response = HTTParty.get("#{@configs['API_BASE_URL']}?key=#{@api_key}&action=services")
      if JSON.parse(response.body).instance_of? Hash and JSON.parse(response.body).key? 'error'
        raise APIError
      end
      # Stores response from the API into a variable and parses it as json
      services = response.body

      #Uses a method from Utils to save the response into services.json
      Utils.store_services(services)
    rescue APIError
      return nil
    end 
  end

  # Sends API request to retrive status update on order(s)
  def Api.check_status(order_id)
    # GET request
    begin
      response = HTTParty.get("#{@configs['API_BASE_URL']}?key=#{@api_key}&action=status&order=#{order_id}")
      if JSON.parse(response.body).instance_of? Hash and JSON.parse(response.body).key? 'error'
        raise APIError
      end
      # Stores response from API into a variable and parses it as json
      order_status = response.body
      # Returns variable with API response
      return JSON.parse(order_status)
    rescue APIError
      return nil
    end
  end

  class APIError < StandardError
    def initialize(msg="An Api error has occured")
      super
    end
  end

end


