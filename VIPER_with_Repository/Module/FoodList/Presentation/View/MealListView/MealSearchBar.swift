import UIKit

internal class MealSearchBar: UISearchBar {
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
