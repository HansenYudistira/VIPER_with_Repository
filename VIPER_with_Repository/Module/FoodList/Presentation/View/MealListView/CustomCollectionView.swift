import UIKit

internal class CustomCollectionView: UICollectionView {
    let identifier: String

    init(axis: UICollectionView.ScrollDirection, cellIdentifier: String) {
        identifier = cellIdentifier
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = axis
        super.init(frame: .zero, collectionViewLayout: layout)
        self.register(UICollectionView.self, forCellWithReuseIdentifier: cellIdentifier)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomCollectionView {
    func setColumns(_ columns: Int, spacing: CGFloat = 8.0) {
        if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
            let totalSpacing = spacing * CGFloat(columns - 1)
            let availableWidth = UIScreen.main.bounds.width - totalSpacing - 16
            let itemWidth = availableWidth / CGFloat(columns)
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
            flowLayout.minimumInteritemSpacing = spacing
            flowLayout.minimumLineSpacing = spacing
            self.collectionViewLayout.invalidateLayout()
        }
    }
}
