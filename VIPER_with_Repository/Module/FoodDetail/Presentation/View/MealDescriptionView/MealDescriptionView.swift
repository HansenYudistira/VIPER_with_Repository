import UIKit

internal class MealDescriptionView: UIStackView {
    private let meal: MealModel
    init(meal: MealModel, frame: CGRect = .zero) {
        self.meal = meal
        super.init(frame: frame)
        setupView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        axis = .vertical
        spacing = 8
        translatesAutoresizingMaskIntoConstraints = false

        let areaLabel = AreaLabelButton()
        areaLabel.configure(text: meal.strArea)
        areaLabel.isUserInteractionEnabled = false
        addArrangedSubview(areaLabel)

        let ingredients: String
        if meal.strIngredients.count == meal.strMeasure.count {
            ingredients = zip(meal.strMeasure, meal.strIngredients)
                .compactMap { measure, ingredient in
                    guard !measure.isEmpty, !ingredient.isEmpty else { return nil }
                    return "\(measure) of \(ingredient)"
                }
                .joined(separator: "\n")
        } else {
            ingredients = LocalizedKey.invalidDataMismatch.localized
        }
        let ingredientsLabel = DescriptionLabelView(
            numberOfLines: 3,
            title: LocalizedKey.instructions.localized,
            description: ingredients
        )
        addArrangedSubview(ingredientsLabel)

        let instructionsLabel = DescriptionLabelView(
            numberOfLines: 7,
            title: LocalizedKey.instructions.localized,
            description: meal.strInstructions
        )
        addArrangedSubview(instructionsLabel)

        if !meal.strYoutube.isEmpty {
            let linkButton = UIButton(type: .system)
            linkButton.setTitle(LocalizedKey.onYoutube.localized, for: .normal)
            linkButton.setTitleColor(.black, for: .normal)
            linkButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            linkButton.contentHorizontalAlignment = .leading
            linkButton.accessibilityLabel = LocalizedKey.onYoutube.localized
            linkButton.addTarget(self, action: #selector(openYouTube), for: .touchUpInside)
            addArrangedSubview(linkButton)
        }
    }

    @objc private func openYouTube() {
        if let url = URL(string: meal.strYoutube) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
