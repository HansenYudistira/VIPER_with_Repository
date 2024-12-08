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
//        let mockData = MockData.createMockMealListModel()
//        self.meals = mockData.meals.map { $0.toViewModel() }
//        let area = self.meals.map { $0.area }
//        self.uniqueArea = Array(Set(area))
//        view.showmeals(meals: self.applyFilters(), uniqueArea: self.uniqueArea)
//        return
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

internal struct MockData {
    static func createMockMealListModel() -> MealListModel {
        let mockMeals = [
            MealModel(
                idMeal: "1",
                strMeal: "Spaghetti Carbonara",
                strArea: "Italian",
                strInstructions: "Cook spaghetti. In a bowl, mix eggs, cheese, and pepper. Combine with cooked spaghetti and pancetta.",
                strMealThumb: "https://via.placeholder.com/150",
                strYoutube: "https://www.youtube.com/watch?v=example1",
                strIngredients: ["Spaghetti", "Eggs", "Cheese", "Pancetta", "Pepper"],
                strMeasure: ["200g", "2", "50g", "100g", "1 tsp"]
            ),
            MealModel(
                idMeal: "2",
                strMeal: "Chicken Curry",
                strArea: "Indian",
                strInstructions: "Cook chicken with spices. Add coconut milk. Simmer until tender. Serve with rice.",
                strMealThumb: "https://via.placeholder.com/150",
                strYoutube: "https://www.youtube.com/watch?v=example2",
                strIngredients: ["Chicken", "Coconut Milk", "Onion", "Tomato", "Spices"],
                strMeasure: ["500g", "1 cup", "1", "2", "to taste"]
            ),
            MealModel(
                idMeal: "3",
                strMeal: "Sushi",
                strArea: "Japanese",
                strInstructions: "Prepare sushi rice. Slice fish. Assemble sushi rolls with nori, rice, and fish.",
                strMealThumb: "https://via.placeholder.com/150",
                strYoutube: "https://www.youtube.com/watch?v=example3",
                strIngredients: ["Rice", "Nori", "Fish", "Soy Sauce", "Wasabi"],
                strMeasure: ["200g", "5 sheets", "100g", "to taste", "to taste"]
            )
        ]
        return MealListModel(meals: mockMeals, searchKey: "Mock")
    }
}
