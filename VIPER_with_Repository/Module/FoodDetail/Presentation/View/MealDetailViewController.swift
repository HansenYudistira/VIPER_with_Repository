import UIKit

internal class MealDetailViewController: UIViewController {
    let presenter: MealDetailPresenterProtocol

    init(presenter: MealDetailPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
