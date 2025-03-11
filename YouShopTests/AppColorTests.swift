import XCTest
@testable import YouShop

final class AppColorTests: XCTestCase {
    func testColorValues() {
        // Test primary color values
        XCTAssertEqual(AppColor.primaryColor, "#5411D8")
        XCTAssertEqual(AppColor.primaryColorLight, "#5E17EB")
        XCTAssertEqual(AppColor.primaryColorDark, "#6441FF")
        
        // Test background colors
        XCTAssertEqual(AppColor.whiteBackgroundColor, "fdfdfd")
        XCTAssertEqual(AppColor.blackBackgroundColor, "020402")
    }
}

// End of file. No additional code.
