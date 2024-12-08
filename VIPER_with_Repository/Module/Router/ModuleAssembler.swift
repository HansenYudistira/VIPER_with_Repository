import UIKit

protocol Module {
    associatedtype ViewController: UIViewController
    associatedtype Parameters
    func assemble(router: Router, parameters: Parameters) -> ViewController
}

internal class ModuleAssembler {
    func assemble<T: Module>(
        module: T,
        router: Router,
        parameters: T.Parameters
    ) -> T.ViewController {
        return module.assemble(router: router, parameters: parameters)
    }
}

struct MealListModule: Module {
    func assemble(router: Router, parameters: String = "") -> MealListViewController {
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
    func assemble(router: Router, parameters: MealModel) -> MealDetailViewController {
        let presenter = MealDetailPresenter(mealModel: parameters)
        return MealDetailViewController(presenter: presenter)
    }
}
