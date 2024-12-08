protocol MealListInteractorProtocol {
    func performSearch(searchKey: String, completion: @escaping (Result<MealListModel, NetworkError>) -> Void)
    func fetchDetailData(_ name: String, completion: (Result<MealModel, NetworkError>) -> Void)
}

internal class MealListInteractor {
    private let apiService: APIService
    private let repository: MealListRepositoryProtocol
    private var cachedMealList: MealListModel?

    init(apiService: APIService = APIService(), repository: MealListRepositoryProtocol) {
        self.apiService = apiService
        self.repository = repository
    }

    internal func fetchDetailData(_ name: String, completion: (Result<MealModel, NetworkError>) -> Void) {
        if let model = cachedMealList?.meals.first(where: {
            $0.strMeal == name
        }) {
            completion(.success(model))
        } else {
            completion(.failure(.noData))
        }
    }
}

extension MealListInteractor: MealListInteractorProtocol {
    internal func performSearch(searchKey: String, completion: @escaping (Result<MealListModel, NetworkError>) -> Void) {
        if let cachedMealList = cachedMealList, cachedMealList.searchKey == searchKey {
            completion(.success(cachedMealList))
            return
        }

        self.cachedMealList = MockData.createMockMealListModel()
        guard
            let cachedMealList = self.cachedMealList
        else {
            completion(.failure(.invalidResponse))
            return
        }
        completion(.success(cachedMealList))

//        let url: String = apiService.baseURL + "search.php?s=\(searchKey)"
//        repository.fetchMeals(url: url) { result in
//            switch result {
//            case .success(let mealsDTO):
//                let meals = mealsDTO.map {
//                    $0.toDomain()
//                }
//                self.cachedMealList = MealListModel(meals: meals, searchKey: searchKey)
//                guard
//                    let cachedMealList = self.cachedMealList
//                else {
//                    completion(.failure(.invalidResponse))
//                    return
//                }
//                completion(.success(cachedMealList))
//            case.failure:
//                completion(.failure(.unknownError))
//            }
//        }
    }
}

internal struct MockData {
    static func createMockMealListModel() -> MealListModel {
        let mockMeals = [
            MealModel(
                idMeal: "1",
                strMeal: "Spaghetti Carbonara",
                strArea: "Italian",
                strInstructions: "Cook spaghetti. Put spaghetti on the street.",
                strMealThumb: "https://via.placeholder.com/150",
                strYoutube: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                strIngredients: ["Spaghetti", "Eggs", "Cheese", "Pancetta", "Pepper"],
                strMeasure: ["200g", "2", "50g", "100g", "1 tsp"]
            ),
            MealModel(
                idMeal: "2",
                strMeal: "Chicken Curry",
                strArea: "Indian",
                strInstructions: "Cook chicken with spices. Add coconut milk. Simmer until tender. Serve with rice.",
                strMealThumb: "https://via.placeholder.com/150",
                strYoutube: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                strIngredients: ["Chicken", "Coconut Milk", "Onion", "Tomato", "Spices"],
                strMeasure: ["500g", "1 cup", "1", "2", "to taste"]
            ),
            MealModel(
                idMeal: "3",
                strMeal: "Sushi",
                strArea: "Japanese",
                strInstructions: "Prepare sushi rice. Slice fish. Assemble sushi rolls with nori, rice, and fish.",
                strMealThumb: "https://via.placeholder.com/150",
                strYoutube: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
                strIngredients: ["Rice", "Nori", "Fish", "Soy Sauce", "Wasabi"],
                strMeasure: ["200g", "5 sheets", "100g", "to taste", "to taste"]
            )
        ]
        return MealListModel(meals: mockMeals, searchKey: "Mock")
    }
}
