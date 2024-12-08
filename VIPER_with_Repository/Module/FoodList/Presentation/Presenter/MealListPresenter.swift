protocol MealListPresenterProtocol {
    func fetchSearchText(_ text: String)
}

protocol MealListFilterProtocol {
    func applyFilters(activeFilters: Set<String>, meals: [MealViewModel]) -> [MealViewModel]
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
//        let mockData = MockData.createMockMealListModel()
//        let viewModels = mockData.meals.map { $0.toViewModel() }
//        let area = viewModels.map { $0.area }
//        let uniqueArea = Array(Set(area))
//        view.showmeals(meals: viewModels, uniqueArea: uniqueArea)
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
                let viewModels = meals.meals.map { $0.toViewModel() }
                let area = viewModels.map { $0.area }
                let uniqueArea = Array(Set(area))
                view.showmeals(meals: viewModels, uniqueArea: uniqueArea)
            case .failure(let error):
                view.showError(error.localizedDescription)
            }
            view.hideLoading()
        }
    }
}

extension MealListPresenter: MealListFilterProtocol {
    func applyFilters(activeFilters: Set<String>, meals: [MealViewModel]) -> [MealViewModel] {
        if activeFilters.isEmpty {
            return meals
        } else {
            return meals.filter { meal in
                activeFilters.contains(meal.area)
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
