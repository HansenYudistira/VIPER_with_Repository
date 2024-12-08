import UIKit

internal class FirstRouter: Router {
    var navigationController: UINavigationController
    let moduleAssembler: ModuleAssembler

    init(
        navigationController: UINavigationController,
        moduleAssembler: ModuleAssembler = ModuleAssembler()
    ) {
        self.navigationController = navigationController
        self.moduleAssembler = moduleAssembler
    }

    func start() {
        let mealListModule = MealListModule()
        let vc = moduleAssembler.assemble(module: mealListModule, router: self)
        navigationController.pushViewController(vc, animated: true)
    }
}
