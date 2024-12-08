import UIKit

internal class MealSearchBar: UISearchBar {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.translatesAutoresizingMaskIntoConstraints = false
        self.placeholder = "Search meals..."
        self.setImage(UIImage(systemName: "text.magnifyingglass"), for: .resultsList, state: .normal)
        self.setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
