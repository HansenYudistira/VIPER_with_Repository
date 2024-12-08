protocol MealListRepositoryProtocol {
    func fetchMeals(url: String, completion: @escaping (Result<[MealResponseDTO], Error>) -> Void)
}

internal class MealListRepository {
    private let networkManager: APIClient
    private let dataDecoder: DataDecoderProtocol

    init(networkManager: APIClient, dataDecoder: DataDecoderProtocol) {
        self.networkManager = networkManager
        self.dataDecoder = dataDecoder
    }
}

extension MealListRepository: MealListRepositoryProtocol {
    internal func fetchMeals(
        url: String,
        completion: @escaping (Result<[MealResponseDTO], Error>) -> Void
    ) {
        networkManager.get(url: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let mealListReponse: MealListResponseDTO = try self.dataDecoder.decode(
                        MealListResponseDTO.self,
                        from: data
                    )
                    completion(.success(mealListReponse.meals))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
