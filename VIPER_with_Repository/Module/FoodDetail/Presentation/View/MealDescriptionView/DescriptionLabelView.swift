import UIKit

internal class DescriptionLabelView: UIStackView {
    init(
        numberOfLines: Int,
        title: String,
        description: String,
        frame: CGRect = .zero) {
            super.init(frame: frame)
            setupView(numberOfLines: numberOfLines,
                      title: title,
                      description: description)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(numberOfLines: Int,
                           title: String,
                           description: String) {
        axis = .vertical

        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.numberOfLines = 1

        let descriptionLabel = UILabel()
        descriptionLabel.text = description
        descriptionLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descriptionLabel.numberOfLines = numberOfLines

        addArrangedSubview(titleLabel)
        addArrangedSubview(descriptionLabel)
    }
}
