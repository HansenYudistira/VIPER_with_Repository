import UIKit
import Kingfisher

internal class MealDetailView: UIView {
    init(meal: MealModel, frame: CGRect = .zero) {
        super.init(frame: frame)
        setupView(meal: meal)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView(meal: MealModel) {
        translatesAutoresizingMaskIntoConstraints = false

        let imageView: MealImageView = .init()
        imageView.accessibilityLabel = meal.strMeal
        if let url = URL(string: meal.strMealThumb) {
            imageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholder"),
                options: [.cacheOriginalImage]
            )
        }
        addSubview(imageView)

        let areaLabel = AreaLabelButton()
        areaLabel.configure(text: meal.strArea)
        areaLabel.isUserInteractionEnabled = false
        addSubview(areaLabel)

        let descriptionView: MealDescriptionView = .init(meal: meal)
        addSubview(descriptionView)

        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            areaLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            areaLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionView.topAnchor.constraint(equalTo: areaLabel.bottomAnchor, constant: 8),
            descriptionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        ])
    }
}
