class Order

    def initialize(order_service, order_link, order_quantity)
        @order_service = order_service
        @order_link = order_link
        @order_quantity = order_quantity

        order_response = Api.order_new(@order_service, @order_link, @order_quantity)

        puts order_response[:response]

        if order_response[:response_code] === 200
            # puts order_response[:response].class
            # puts order_response[:response]
        else
        end
    end

end