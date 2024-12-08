import UIKit

enum LocalizedKey: String {
    case chooseYourMenu

    var localized: String {
        let key = String(describing: self)
        return NSLocalizedString(key, comment: self.comment)
    }

    private var comment: String {
        switch self {
        case .chooseYourMenu:
            return "Title for the menu selection screen"
        }
    }
}
