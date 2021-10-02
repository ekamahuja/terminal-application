module Api

  Dotenv.load('./.env')
  @api_key = ENV['API_KEY']

  def Api.order_new(order_service, order_link, order_quantity)
    begin
      response = HTTParty.get("https://topnotchgrowth.com/api/v2?key="+ @api_key +"&action=add&service=#{order_service}&link=#{order_link}&quantity=#{order_quantity}")
      new_order_response = {
          "response": response.body,
          "response_code": response.code
      }
      return new_order_response
  rescue 
    return nil
    end
  end

  def Api.fetch_services
    begin  
      response = HTTParty.get("https://topnotchgrowth.com/api/v2?key="+ @api_key +"&action=services")
      services = response.body
      Utils.store_services(services)
    rescue 
      puts "something went wrong"
    end 
  end

    def Api.check_status(order_id)
        response = HTTParty.get("https://topnotchgrowth.com/api/v2?key=#{@api_key}&action=status&order=#{order_id}")
        order_status = response.body
        return JSON.parse(order_status)
    end
end


