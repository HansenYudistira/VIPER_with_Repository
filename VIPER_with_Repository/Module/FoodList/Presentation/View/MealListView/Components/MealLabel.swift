import UIKit

internal class MealLabel: UILabel {
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabel() {
        font = .systemFont(ofSize: 14, weight: .bold)
        textColor = .black
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
