import CoreText

struct FontManager {
    enum AfacadWeight {
        case regular
        case medium
        case semiBold
        case bold
        case italics
        
        var fileName: String {
            switch self {
            case .regular:
                return "Afacad-Regular"
            case .medium:
                return "Afacad-Medium"
            case .semiBold:
                return "Afacad-SemiBold"
            case .bold:
                return "Afacad-Bold"
            case .italics:
                return "Afacad-Italic"
            }
        }
    }
    
    static func afacad(_ size: CGFloat, weight: AfacadWeight = .regular) -> Font {
        return Font.custom(weight.fileName, size: size)
    }
    
    static func registerFonts() {
        let weights: [AfacadWeight] = [.regular, .medium, .semiBold, .bold, .italics]
        
        for weight in weights {
            guard let fontURL = Bundle.main.url(forResource: weight.fileName, withExtension: "ttf") else {
                printIfDebug("Failed to find font file for \(weight.fileName).")
                continue
            }
            
            let result = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
            if result {
//                print("Successfully registered \(weight.fileName) font!")
            } else {
                print("Failed to register \(weight.fileName) font.")
            }
        }
    }
}


// Extension to make font usage more convenient
extension View {
    func afacadFont(_ size: CGFloat, weight: FontManager.AfacadWeight = .regular) -> some View {
        self.font(FontManager.afacad(size, weight: weight))
    }
}
