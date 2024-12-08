typealias MealListPresenterProtocol = MealListFetchProtocol & MealListFilterProtocol & NavigateToDetailProtocol

protocol MealListFetchProtocol {
    func fetchSearchText(_ text: String)
}

protocol MealListFilterProtocol {
    func applyFilters() -> [MealViewModel]
    func toggleFilter(for area: String)
}

protocol NavigateToDetailProtocol {
    func navigateToDetail(with meal: MealViewModel)
}

internal class MealListPresenter {
    let interactor: MealListInteractorProtocol
    let router: Router
    weak var view: MealListViewProtocol?
    private var meals: [MealViewModel] = []
    private var filteredMeals: [MealViewModel] = []
    private var uniqueArea: [String] = []
    private var activeFilters: Set<String> = []

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
                self.meals = meals.meals.map { $0.toViewModel() }
                let area = self.meals.map { $0.area }
                self.uniqueArea = Array(Set(area))
                view.showmeals(meals: self.applyFilters(), uniqueArea: self.uniqueArea)
            case .failure(let error):
                view.showError(error.localizedDescription)
            }
            view.hideLoading()
        }
    }

    func applyFilters() -> [MealViewModel] {
        if activeFilters.isEmpty {
            filteredMeals = meals
        } else {
            filteredMeals = meals.filter { meal in
                activeFilters.contains(meal.area)
            }
        }
        return filteredMeals
    }

    func toggleFilter(for area: String) {
        if activeFilters.contains(area) {
            activeFilters.remove(area)
        } else {
            activeFilters.insert(area)
        }
    }

    func navigateToDetail(with meal: MealViewModel) {
        interactor.fetchDetailData(meal.name) { result in
            switch result {
            case .success(let meal):
                router.navigate(to: .mealDetails(meal))
            case .failure(let error):
                view?.showError(error.errorDescription ?? "Something went wrong")
            }
        }
    }
}
