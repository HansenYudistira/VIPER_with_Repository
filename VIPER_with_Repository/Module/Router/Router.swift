import UIKit

enum Destination {
    case mealList
    case mealDetails(MealModel)
}

protocol Router: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func navigate(to destination: Destination)
}

internal class AppRouter: Router {
    internal var navigationController: UINavigationController
    private let window: UIWindow
    let moduleAssembler: ModuleAssembler

    init(
        window: UIWindow,
        navigationController: UINavigationController,
        moduleAssembler: ModuleAssembler = ModuleAssembler()
    ) {
        self.window = window
        self.navigationController = navigationController
        self.moduleAssembler = moduleAssembler
    }

    internal func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        navigate(to: .mealList)
    }

    func navigate(to destination: Destination) {
        switch destination {
        case .mealList:
            let mealListModule = MealListModule()
            let vc = moduleAssembler.assemble(module: mealListModule, router: self, parameters: "")
            navigationController.pushViewController(vc, animated: true)
        case .mealDetails(let meal):
            let mealDetailModule = MealDetailModule()
            let detailVC = moduleAssembler.assemble(module: mealDetailModule, router: self, parameters: meal)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
