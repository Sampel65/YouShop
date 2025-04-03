import Foundation

struct Order: Identifiable, Codable {
    let id: String
    let items: [Product: Int]
    let total: Double
    let address: String
    let paymentMethod: String
    var status: OrderStatus 
    let date: Date
    
    var itemCount: Int {
        items.values.reduce(0, +)
    }
}

enum OrderStatus: String, Codable, CaseIterable {
    case processing = "Processing"
    case shipped = "Shipped"
    case delivered = "Delivered"
    case returned = "Returned"
    case cancelled = "Cancelled"
    
    var color: String {
        switch self {
        case .processing: return AppColor.primaryColor
        case .shipped: return AppColor.warningColor
        case .delivered: return AppColor.primaryColorLight
        case .returned: return AppColor.textRed
        case .cancelled: return AppColor.textGrey
        }
    }
}
