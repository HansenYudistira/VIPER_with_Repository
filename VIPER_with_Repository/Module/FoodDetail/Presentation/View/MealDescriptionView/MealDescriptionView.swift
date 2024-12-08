import UIKit

internal class MealDescriptionView: UIStackView {
    let meal: MealModel
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
        addArrangedSubview(areaLabel)

        if !meal.strYoutube.isEmpty {
            let linkButton = UIButton(type: .system)
            linkButton.setTitle(LocalizedKey.onYoutube.localized, for: .normal)
            linkButton.setTitleColor(.black, for: .normal)
            linkButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            linkButton.contentHorizontalAlignment = .leading
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
