import UIKit

internal class MealDetailViewController: UIViewController {
    private let presenter: MealDetailPresenterProtocol
    private let mealModel: MealModel

    init(presenter: MealDetailPresenterProtocol) {
        self.presenter = presenter
        self.mealModel = presenter.fetchDetailData()
        super.init(nibName: nil, bundle: nil)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        navigationItem.title = mealModel.strMeal
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: LocalizedKey.back.localized,
            style: .plain,
            target: nil,
            action: nil
        )
        view.backgroundColor = .white

        let mealDetailView: MealDetailView = .init(meal: mealModel)
        view.addSubview(mealDetailView)

        NSLayoutConstraint.activate([
            mealDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mealDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mealDetailView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mealDetailView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
