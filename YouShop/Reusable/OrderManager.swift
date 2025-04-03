import Foundation

class OrderManager: ObservableObject {
    static let shared = OrderManager()
    
    @Published var orders: [Order] = []
    private let ordersKey = "stored_orders"
    private let notificationManager = NotificationManager.shared
    
    init() {
        loadOrders()
    }
    
    func addOrder(items: [Product: Int], total: Double, address: String, paymentMethod: String) {
        let orderId = UUID().uuidString
        let order = Order(
            id: orderId,
            items: items,
            total: total,
            address: address,
            paymentMethod: paymentMethod,
            status: .processing,
            date: Date()
        )
        
        DispatchQueue.main.async {
            self.orders.insert(order, at: 0) // Add new orders at the top
            self.saveOrders()
            
            // Send notification for new order
            self.notificationManager.sendOrderNotification(orderId: orderId)
        }
    }
    
    func updateOrderStatus(_ orderId: String, status: OrderStatus) {
        if let index = orders.firstIndex(where: { $0.id == orderId }) {
            var updatedOrder = orders[index]
            updatedOrder.status = status
            orders[index] = updatedOrder
            saveOrders()
            
            // Send notification for status update
            notificationManager.addNotification("Order #\(orderId) status updated to \(status.rawValue)")
        }
    }
    
    private func saveOrders() {
        if let encoded = try? JSONEncoder().encode(orders) {
            UserDefaults.standard.set(encoded, forKey: ordersKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    private func loadOrders() {
        if let data = UserDefaults.standard.data(forKey: ordersKey),
           let decoded = try? JSONDecoder().decode([Order].self, from: data) {
            self.orders = decoded.sorted(by: { $0.date > $1.date })
        }
    }
    
    func clearAllOrders() {
        orders.removeAll()
        saveOrders()
    }
    
    func getOrder(by id: String) -> Order? {
        return orders.first { $0.id == id }
    }
}

// Extension to make Order mutable for status updates
extension Order {
    mutating func updateStatus(_ newStatus: OrderStatus) {
        self.status = newStatus
    }
}
