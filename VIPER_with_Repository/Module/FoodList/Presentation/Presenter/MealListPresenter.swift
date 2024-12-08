protocol MealListPresenterProtocol {
    func fetchSearchText(_ text: String)
}

internal class MealListPresenter {
    let interactor: MealListInteractorProtocol
    let router: Router
    weak var view: MealListViewProtocol?

    init(interactor: MealListInteractorProtocol, router: Router) {
        self.interactor = interactor
        self.router = router
    }
}

extension MealListPresenter: MealListPresenterProtocol {
    func fetchSearchText(_ text: String) {
        guard
            let view = self.view
        else {
            return
        }
        view.showLoading()

        interactor.performSearch(searchKey: text) { [weak self] result in
            guard
                let self = self,
                let view = self.view
            else {
                return
            }
            switch result {
            case .success(let meals):
                let viewModels = meals.meals.map { $0.toViewModel() }
                view.showmeals(viewModels)
            case .failure(let error):
                view.showError(error.localizedDescription)
            }
            view.hideLoading()
        }
    }
}
