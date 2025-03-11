import XCTest
@testable import YouShop

final class FontManagerTests: XCTestCase {
    func testAfacadWeightFileNames() {
        XCTAssertEqual(FontManager.AfacadWeight.regular.fileName, "Afacad-Regular")
        XCTAssertEqual(FontManager.AfacadWeight.medium.fileName, "Afacad-Medium")
        XCTAssertEqual(FontManager.AfacadWeight.bold.fileName, "Afacad-Bold")
        XCTAssertEqual(FontManager.AfacadWeight.italics.fileName, "Afacad-Italic")
    }
    
    func testFontRegistration() {
        // Test font registration
        FontManager.registerFonts()
        // Note: We can't directly test if fonts are registered in the system,
        // but we can verify the method runs without crashing
    }
}

// End of file. No additional code.
