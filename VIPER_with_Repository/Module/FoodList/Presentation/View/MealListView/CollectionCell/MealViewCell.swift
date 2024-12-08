import UIKit
import Kingfisher

internal class MealCollectionViewCell: UICollectionViewCell {
    private var mealImageView: MealImageView
    private var mealLabel: MealLabel
    private var areaLabel: AreaLabelButton

    override init(frame: CGRect = .zero) {
        self.mealImageView = MealImageView()
        self.mealLabel = MealLabel()
        self.areaLabel = AreaLabelButton()
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .white

        let verticalStackView = UIStackView(arrangedSubviews: [mealImageView, mealLabel, areaLabel])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 8
        verticalStackView.alignment = .top
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            mealImageView.heightAnchor.constraint(equalTo: verticalStackView.heightAnchor, multiplier: 0.75),
            mealImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mealImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mealImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mealLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 4),
            mealLabel.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor, constant: -4),
            areaLabel.leadingAnchor.constraint(equalTo: verticalStackView.leadingAnchor, constant: 4)
        ])
    }

    override internal func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view === areaLabel {
            return contentView
        }
        return view
    }

    internal func configure(with meal: MealViewModel) {
        self.mealImageView.accessibilityLabel = meal.name
        self.mealLabel.text = meal.name
        self.areaLabel.configure(text: meal.area)

        if let url = URL(string: meal.imageURL) {
            self.mealImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [.cacheOriginalImage]
            )
        }
    }
}
