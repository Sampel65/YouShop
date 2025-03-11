import XCTest
import Firebase
@testable import YouShop

class AuthViewModelTests: XCTestCase {
    var authViewModel: AuthViewModel!
    
    override func setUp() {
        super.setUp()
        authViewModel = AuthViewModel()
    }
    
    override func tearDown() {
        authViewModel = nil
        super.tearDown()
    }
    
    func testEmailValidation() {
        // Test invalid email
        authViewModel.signUp(email: "invalid-email", password: "password123", name: "Test User", phone: "1234567890", address: "Test Address") { success, message in
            XCTAssertFalse(success)
            XCTAssertEqual(message, "Invalid email format")
        }
        
        // Test valid email
        authViewModel.signUp(email: "test@example.com", password: "password123", name: "Test User", phone: "1234567890", address: "Test Address") { success, _ in
            // This might fail due to Firebase rules, but email format is valid
            XCTAssertNotEqual(success, false)
        }
    }
    
    func testPhoneValidation() {
        // Test invalid phone
        authViewModel.signUp(email: "test@example.com", password: "password123", name: "Test User", phone: "123", address: "Test Address") { success, message in
            XCTAssertFalse(success)
            XCTAssertEqual(message, "Invalid phone number")
        }
        
        // Test valid phone
        authViewModel.signUp(email: "test@example.com", password: "password123", name: "Test User", phone: "1234567890", address: "Test Address") { success, _ in
            // This might fail due to Firebase rules, but phone format is valid
            XCTAssertNotEqual(success, false)
        }
    }
    
    func testSignOut() {
        authViewModel.signOut()
        XCTAssertNil(authViewModel.user)
        XCTAssertFalse(authViewModel.isAuthenticated)
    }
}

