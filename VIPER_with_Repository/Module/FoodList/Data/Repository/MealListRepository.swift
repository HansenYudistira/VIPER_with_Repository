protocol MealListRepositoryProtocol {
    func fetchMeals(url: String, completion: @escaping (Result<[MealResponseDTO], Error>) -> Void) async throws
}

internal class MealListRepository: MealListRepositoryProtocol {
    private let networkManager: APIClient
    private let dataDecoder: DataDecoderProtocol

    init(networkManager: APIClient, dataDecoder: DataDecoderProtocol) {
        self.networkManager = networkManager
        self.dataDecoder = dataDecoder
    }

    internal func fetchMeals(
        url: String,
        completion: @escaping (Result<[MealResponseDTO], Error>) -> Void
    ) async throws {
        do {
            let data = try await networkManager.get(url: url)
            let mealListReponse: MealListResponseDTO = try dataDecoder.decode(MealListResponseDTO.self, from: data)
            completion(.success(mealListReponse.meals))
        } catch {
            completion(.failure(error))
        }
    }
}
