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
    func performSearch(searchKey: String, completion: @escaping (Result<MealListModel, NetworkError>) -> Void) {
        if let cachedMealList = cachedMealList, cachedMealList.searchKey == searchKey {
            completion(.success(cachedMealList))
            return
        }

        let url = apiService.baseURL + "search.php?s=\(searchKey)"
        repository.fetchMeals(url: url) { result in
            switch result {
            case .success(let mealsDTO):
                let meals = mealsDTO.map {
                    $0.toDomain()
                }
                self.cachedMealList = MealListModel(meals: meals, searchKey: searchKey)
                guard
                    let cachedMealList = self.cachedMealList
                else {
                    completion(.failure(.invalidResponse))
                    return
                }
                completion(.success(cachedMealList))
            case.failure:
                completion(.failure(.unknownError))
            }
        }
    }
}
