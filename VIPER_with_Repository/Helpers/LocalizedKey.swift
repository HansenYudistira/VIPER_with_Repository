import UIKit

enum LocalizedKey: String {
    case chooseYourMenu
    case onYoutube
    case searchHere
    case error
    case ok
    case back

    var localized: String {
        let key: String = String(describing: self)
        return NSLocalizedString(key, comment: self.comment)
    }

    private var comment: String {
        switch self {
        case .chooseYourMenu:
            return "Title for the menu selection screen"
        case .onYoutube:
            return "Available on the youtube"
        case .searchHere:
            return "Placeholder text in a search bar prompting users to search for a meal."
        case .error:
            return "Something Wrong."
        case .ok:
            return "Okay."
        case .back:
            return "Back."
        }
    }
}
