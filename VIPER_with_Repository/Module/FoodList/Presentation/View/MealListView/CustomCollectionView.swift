import UIKit

internal class CustomCollectionView: UICollectionView {
    let identifier: String

    init(axis: UICollectionView.ScrollDirection, cellIdentifier: String, frame: CGRect = .zero) {
        identifier = cellIdentifier
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = axis
        super.init(frame: frame, collectionViewLayout: layout)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func removeScrollIndicator() {
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
}
