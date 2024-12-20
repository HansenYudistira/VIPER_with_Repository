import XCTest
@testable import VIPER_with_Repository

final class MockRepository: MealListRepositoryProtocol {
    func fetchMeals(url: String, completion: @escaping (Result<[MealResponseDTO], any Error>) -> Void) {
        let mockJSONString = """
                {
                    "meals": [
                        {
                            "idMeal": "52795",
                            "strMeal": "Chicken Handi",
                            "strArea": "Indian",
                            "strInstructions": "Some instructions",
                            "strMealThumb": "https://www.themealdb.com/images/media/meals/wyxwsp1486979827.jpg",
                            "strYoutube": "https://www.youtube.com/watch?v=IO0issT0Rmc",
                            "strIngredient1": "Chicken",
                            "strIngredient2": "Onion",
                            "strIngredient3": "Tomatoes",
                            "strMeasure1": "1.2 kg",
                            "strMeasure2": "5 thinly sliced",
                            "strMeasure3": "2 finely chopped"
                        }
                    ]
                }
                """
        guard let data = mockJSONString.data(using: .utf8) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }

        do {
            let mealsResponse = try JSONDecoder().decode(MealListResponseDTO.self, from: data)
            completion(.success(mealsResponse.meals))
        } catch {
            completion(.failure(error))
        }
    }
}

final class MockRepositoryFail: MealListRepositoryProtocol {
    func fetchMeals(
        url: String,
        completion: @escaping (Result<[MealResponseDTO], any Error>) -> Void
    ) {
        completion(.failure(NetworkError.unknownError))
    }
}

final class MealListInteractorTests: XCTestCase {
    func testSearchIsSuccess() {
        let expectation = self.expectation(description: "success fetch data from repository")
        let repository = MockRepository()
        let interactor = MealListInteractor(repository: repository)
        interactor.performSearch(searchKey: "chicken") { result in
            switch result {
            case .success(let mealsList):
                XCTAssertEqual(mealsList.meals.count, 1)
                XCTAssertEqual(mealsList.meals[0].idMeal, "52795")
                XCTAssertEqual(mealsList.meals[0].strMeal, "Chicken Handi")
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0)
    }

    func testSearchIsFail() {
        let expectation = self.expectation(description: "fail fetch data from repository")
        let repositoryFail = MockRepositoryFail()
        let interactor = MealListInteractor(repository: repositoryFail)
        interactor.performSearch(searchKey: "chicken") { result in
            switch result {
            case .success:
                XCTFail("Unexpected success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.unknownError)
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 1.0)
    }

    func testFetchDetailData() {
        let expectation = self.expectation(description: "success fetch detailed data from cache")
        let repository = MockRepository()
        let interactor = MealListInteractor(repository: repository)
        interactor.performSearch(searchKey: "Chicken") { _ in }

        interactor.fetchDetailData("Chicken Handi") { result in
            switch result {
            case .success(let meal):
                XCTAssertEqual(meal.idMeal, "52795")
                XCTAssertEqual(meal.strMeal, "Chicken Handi")
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0)
    }
}
