import UIKit

internal class MealSearchBar: UISearchBar {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = .clear
        barTintColor = .clear
        isTranslucent = true
        setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        setSearchFieldBackgroundImage(UIImage(), for: .normal)

        searchTextField.backgroundColor = .white
        searchTextField.borderStyle = .roundedRect
        searchTextField.layer.cornerRadius = 8.0
        searchTextField.clipsToBounds = true

        translatesAutoresizingMaskIntoConstraints = false
        placeholder = LocalizedKey.searchHere.localized
        setImage(UIImage(systemName: "text.magnifyingglass"), for: .resultsList, state: .normal)
        setImage(UIImage(systemName: "magnifyingglass"), for: .search, state: .normal)
    }
}
