import SwiftUI

struct SocialSignInButton: View {
    @Environment(\.colorScheme) var colorScheme
    let service: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(service.lowercased() == "google" ? service.lowercased() : colorScheme == .dark ? "appleWhite" : "appleBlack")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(service)
                    .font(.custom("Metropolis-Regular", size: 16))
                    .foregroundColor(colorScheme == .dark ? .white : .black)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(Color(colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : Color(red: 1, green: 1, blue: 1)))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(colorScheme == .dark ? AppColor.socialButtonDarkColor : AppColor.socialButtonLightColor), lineWidth: 2)
            )
        }
    }
}

