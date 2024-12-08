import UIKit

protocol Module {
    associatedtype ViewController: UIViewController
    func assemble(router: Router) -> ViewController
}

internal class ModuleAssembler {
    func assemble<T: Module>(module: T, router: Router) -> T.ViewController {
        return module.assemble(router: router)
    }
}

struct MealListModule: Module {
    func assemble(router: Router) -> MealListViewController {
        let decoder = DataDecoder()
        let responseValidator = ResponseValidator()
        let networkManager = NetworkManager(responseValidator: responseValidator)
        let repository = MealListRepository(networkManager: networkManager, dataDecoder: decoder)
        let interactor = MealListInteractor(repository: repository)
        let presenter = MealListPresenter(interactor: interactor, router: router)
        let viewController = MealListViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}

struct MealDetailModule: Module {
    func assemble(router: Router) -> MealDetailViewController {
        let presenter = MealDetailPresenter()
        return MealDetailViewController(presenter: presenter)
    }
}
