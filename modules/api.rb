module Api

    def Api.order_new(order_service, order_link, order_quantity)
        response = HTTParty.get("https://topnotchgrowth.com/api/v2?key=c2623c04dcd24d138824a8d8c8177446&action=add&service=#{order_service}&link=#{order_link}&quantity=#{order_quantity}")
            
        # puts response.body, response.code, response.message, response.headers.inspect
        new_order_response = {
            "response": response.body,
            "response_code": response.code
        }
        
        return new_order_response
    end



    def Api.fetch_services
        response = HTTParty.get("https://topnotchgrowth.com/api/v2?key=c2623c04dcd24d138824a8d8c8177446&action=services")
        services = response.body
        Utils.store_services(services)
    end


end
    
