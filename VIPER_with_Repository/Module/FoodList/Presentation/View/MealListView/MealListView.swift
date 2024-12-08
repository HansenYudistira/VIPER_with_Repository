import UIKit

internal class MealListView: UIStackView {
    let searchBar: MealSearchBar
    let filterCollection: CustomCollectionView
    let mealCollection: CustomCollectionView

    init() {
        searchBar = MealSearchBar()
        filterCollection = CustomCollectionView(axis: .horizontal, cellIdentifier: "filterCell")
        mealCollection = CustomCollectionView(axis: .vertical, cellIdentifier: "mealCell")
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
