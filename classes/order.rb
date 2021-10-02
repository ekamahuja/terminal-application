class Order

    def initialize(order_service, order_link, order_quantity)
        @order_service = order_service
        @order_link = order_link
        @order_quantity = order_quantity

        order_response = Api.order_new(@order_service, @order_link, @order_quantity)

        puts order_response[:response]

        if order_response[:response_code] === 200
            order_data =  {
                "user_id": Account.get_logged_in_user['id'],
                "order_id": 12,
                "api_provide_order_id": JSON.parse(order_reponse[:reponse])['order'],
                "service_id": @order_service,
                "service_name": "Api test",
                "link": @order_link,
                "quantity": @order_quantity,
                "status": "Pending"
            }
            puts order_data
            Utils.store_order(order_data)
        else
            puts "something went wrong"
        end
    end

    def self.view_history
        rows = []
        orders = Utils.fetch_orders
        user_id = Account.get_logged_in_user['id']
        orders.each do |order|
            if order['user_id'] === user_id
                rows << [order['order_id'], order['service_name'], order['link'], order['quantity'], order['status']]
            end
        end

        table = Terminal::Table.new :headings => ['Order Id', 'Service Name' , 'Link', 'Quantity', 'Status'], :rows => rows
        puts table
    end

end
