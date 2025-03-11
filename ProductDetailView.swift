import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var cartManager: CartManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Product Image
                AsyncImage(url: URL(string: product.image)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 300)
                    case .failure(_):
                        Image(systemName: "photo")
                            .frame(height: 300)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor))
                
                VStack(alignment: .leading, spacing: 12) {
                    YouShopText(product.title, size: 24, weight: .semiBold)
                    
                    YouShopText("$\(String(format: "%.2f", product.price))", size: 20, weight: .semiBold)
                        .foregroundColor(Color(AppColor.primaryColor))
                    
                    YouShopText("Rating: \(String(format: "%.1f", product.rating.rate)) (\(product.rating.count) reviews)", size: 14)
                        .foregroundColor(.gray)
                    
                    YouShopText(product.description, size: 16)
                        .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                
                Spacer()
                
                // Add to Cart Button
                YouShopButton(
                    title: "Add to Cart",
                    height: 56,
                    cornerRadius: 28,
                    action: {
                        cartManager.addToCart(product)
                    }
                )
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

