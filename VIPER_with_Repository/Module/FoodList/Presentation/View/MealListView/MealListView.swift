import UIKit

internal class MealListView: UIStackView {
    internal let searchBar: MealSearchBar
    internal let filterCollection: CustomCollectionView
    internal let mealCollection: CustomCollectionView

    internal let mealIdentifier: String = "mealCell"
    internal let filterIdentifier: String = "filterCell"

    override init(frame: CGRect = .zero) {
        searchBar = MealSearchBar()
        filterCollection = CustomCollectionView(axis: .horizontal, cellIdentifier: filterIdentifier)
        mealCollection = CustomCollectionView(axis: .vertical, cellIdentifier: mealIdentifier)

        super.init(frame: frame)
        setupView()
        setupCollectionView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override internal func layoutSubviews() {
        super.layoutSubviews()
        configureFilterLayout()
        configureMealLayout(columns: 2)
    }

    private func setupView() {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        axis = .vertical
        spacing = 8
        filterCollection.backgroundColor = .clear
        filterCollection.removeScrollIndicator()
        mealCollection.backgroundColor = .clear
        addArrangedSubview(searchBar)
        addArrangedSubview(filterCollection)
        addArrangedSubview(mealCollection)

        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1),
            filterCollection.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.05),
            mealCollection.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8)
        ])
    }

    private func configureFilterLayout() {
        if let flowLayout = filterCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 100, height: 40)
            flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.minimumInteritemSpacing = 8.0
            flowLayout.minimumLineSpacing = 8.0
            flowLayout.scrollDirection = .horizontal
            filterCollection.collectionViewLayout.invalidateLayout()
        }
    }

    private func configureMealLayout(columns: Int, spacing: CGFloat = 8.0) {
        if let flowLayout = mealCollection.collectionViewLayout as? UICollectionViewFlowLayout {
            mealCollection.layoutIfNeeded()
            let totalSpacing = spacing * CGFloat(columns - 1)
            let availableWidth = mealCollection.bounds.width - totalSpacing - 16
            let itemWidth = availableWidth / CGFloat(columns)
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth * 1.25)
            flowLayout.minimumInteritemSpacing = spacing
            flowLayout.minimumLineSpacing = spacing
            flowLayout.scrollDirection = .vertical
            mealCollection.collectionViewLayout.invalidateLayout()
        }
    }

    private func setupCollectionView() {
        filterCollection.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: filterIdentifier)
        mealCollection.register(MealCollectionViewCell.self, forCellWithReuseIdentifier: mealIdentifier)
    }
}
