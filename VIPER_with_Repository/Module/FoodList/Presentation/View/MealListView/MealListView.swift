import UIKit

internal class MealListView: UIStackView {
    let searchBar: MealSearchBar

    init() {
        searchBar = MealSearchBar()
        super.init(frame: .zero)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 8

        addArrangedSubview(searchBar)
    }
}
