import Foundation

class OrderManager: ObservableObject {
    @Published var orders: [Order] = []
    
    static let shared = OrderManager()
    
    private init() {
        loadOrders()
    }
    
    func addOrder(_ order: Order) {
        orders.insert(order, at: 0)
        saveOrders()
    }
    
    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(encoded, forKey: "saved_orders")
        }
    }
    
    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: "saved_orders"),
           let savedOrders = try? JSONDecoder().decode([Order].self, from: data) {
            orders = savedOrders
        }
    }
    
    func updateOrderStatus(_ orderId: String, status: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            var updatedOrder = orders[index]
            updatedOrder = Order(
                id: updatedOrder.id,
                items: updatedOrder.items,
                total: updatedOrder.total,
                address: updatedOrder.address,
                paymentMethod: updatedOrder.paymentMethod,
                status: status,
                date: updatedOrder.date
            )
            orders[index] = updatedOrder
            saveOrders()
        }
    }
}\
