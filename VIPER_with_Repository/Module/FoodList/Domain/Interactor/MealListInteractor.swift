protocol MealListInteractorProtocol {
    func performSearch(searchKey: String, completion: @escaping (Result<MealListModel, Error>) -> Void)
}

internal class MealListInteractor {
    private let apiService: APIService
    private let repository: MealListRepositoryProtocol
    private var cachedMealList: MealListModel?

    init(apiService: APIService = APIService(), repository: MealListRepositoryProtocol) {
        self.apiService = apiService
        self.repository = repository
    }
}

extension MealListInteractor: MealListInteractorProtocol {
    func performSearch(searchKey: String, completion: @escaping (Result<MealListModel, Error>) -> Void) {
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
                    completion(.failure(NetworkError.invalidResponse))
                    return
                }
                completion(.success(cachedMealList))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
