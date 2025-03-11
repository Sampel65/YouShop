# YouShop - iOS E-commerce Application

YouShop is a modern iOS e-commerce application built with SwiftUI, featuring a robust authentication system, real-time notifications, and seamless shopping experience. Here's a comprehensive overview:
## Key Features

1. Authentication & Security:
- Firebase-based authentication system
- Secure user registration and login
- Password reset functionality
- Social sign-in options (Google & Apple)

2. User Interface:
- Custom splash screen with animations
- Dark/Light mode support
- Custom fonts using FontManager
- Reusable UI components (YouShopButton, YouShopTextfield)

3. Shopping Features:
- Product browsing and search
- Category filtering
- Cart management
- Product details view

4. Technical Features:
- Firebase integration
- Push notifications support
- State management using @StateObject and @EnvironmentObject
- Custom color system
- Image caching and lazy loading
- Comprehensive test coverage

  ## Architecture

- MVVM Architecture
- Modular component design
- Separate ViewModels for authentication, cart, and notifications
- Utility managers for fonts and colors
- Unit and integration tests for key components
  ## Technical Stack

- SwiftUI for UI
- Firebase for backend
- UserNotifications framework
- XCTest for testing
- Custom font implementation
- Environment-based state management
  ## Additional Features

1. Performance Optimization:
- Custom image caching system
- Efficient state management
- Lazy loading of product listings
- Task-based concurrency for async operations

2. User Experience:
- Smooth animations and transitions
- Error handling with user-friendly messages
- Form validation with real-time feedback
- Responsive layout supporting all iOS devices

3. Security:
- Secure data storage
- Firebase Authentication integration
- Protected API endpoints
- Secure user data handling

4. Data Management:
- Real-time product updates
- Persistent shopping cart
- User profile management
- Order history tracking

## Installation
1. Clone the repository
2. Install Firebase using CocoaPods or SPM
3. Configure Firebase credentials
4. Run the project in Xcode

## Requirements
- iOS 15.0+
- Xcode 14.0+
- Swift 5.0+
- Firebase account

## Future Enhancements
1. Payment gateway integration
2. Advanced product filtering
3. AR product preview
4. Social sharing features
5. Order tracking system

   # YouShop iOS App

## Installation Instructions

### Prerequisites
- Xcode 14.0 or later
- iOS 15.0 or later
- CocoaPods (if using)
- Active Apple Developer account (free or paid)

### Steps to Run

1. Clone the repository
```bash
git clone https://github.com/Sampel65/YouShop.git

cd YouShop
```

2. Install Dependencies (Choose one)
- Using Swift Package Manager:
   - Open YouShop.xcodeproj
   - Wait for SPM to download dependencies
   - Build the project

- Using CocoaPods:
```bash
pod install
open YouShop.xcworkspace
```
