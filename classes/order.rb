class Order

    def initialize(order_service, order_link, order_quantity)
        @order_service = order_service
        @order_link = order_link
        @order_quantity = order_quantity

        order_response = Api.order_new(@order_service, @order_link, @order_quantity)

        puts order_response[:response_code]

        if order_response[:response_code] === 200
            order_data =  {
                "user_id": Account.get_logged_in_user['id'],
                "order_id": 12,
                "api_provide_order_id": order_response[:response],
                "service_id": @order_service,
                "service_name": "Api test",
                "link": @order_link,
                "quantity": @order_quantity,
                "status": "Pending"
            }
            puts order_data
        else
            puts "Something went wrong"
        end
    
    
    
    end
end