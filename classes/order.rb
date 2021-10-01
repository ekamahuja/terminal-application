class Order

    def initialize(order_service, order_link, order_quantity)
        @order_service = order_service
        @order_link = order_link
        @order_quantity = order_quantity

        order = Api.order_new(@order_service, @order_link, @order_quantity)

        puts order_response[:response]

    end

end