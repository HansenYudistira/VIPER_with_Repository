import XCTest
@testable import VIPER_with_Repository

final class MockNetworkManager: APIClient {
    func get(url: String, completion: @escaping (Result<Data, any Error>) -> Void) {
        guard let data = mockData.data(using: .utf8) else {
            completion(.failure(NetworkError.invalidResponse))
            return
        }
        completion(.success(data))
    }
}

final class MockNetworkManagerFailure: APIClient {
    func get(url: String, completion: @escaping (Result<Data, any Error>) -> Void) {
        completion(.failure(NetworkError.invalidResponse))
    }
}

final class MealListRepositoryTests: XCTestCase {
    let dataDecoder = DataDecoder()

    func testGetMealsIsSuccess() {
        let expectation = self.expectation(description: "Get meals")
        let repository = MealListRepository(
            networkManager: MockNetworkManager(),
            dataDecoder: dataDecoder
        )

        repository.fetchMeals(url: "mockURL") { result in
            switch result {
            case .success(let meals):
                XCTAssertEqual(meals.count, 1, "Expected exactly one meal")
                XCTAssertEqual(meals.first?.idMeal, "52795", "Unexpected meal ID")
                XCTAssertEqual(meals.first?.strMeal, "Chicken Handi", "Unexpected meal name")
            case .failure(let error):
                XCTFail("Expected success, but got failure: \(error)")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0)
    }

    func testGetMealsIsFailure() {
        let expectation = self.expectation(description: "Get meals")
        let repository = MealListRepository(
            networkManager: MockNetworkManagerFailure(),
            dataDecoder: dataDecoder
        )

        repository.fetchMeals(url: "mockURL") { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success instead")
            case .failure(let error):
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidResponse, "Unexpected error type")
            }
            expectation.fulfill()
        }

        waitForExpectations(timeout: 5.0)
    }
}

fileprivate let mockData: String =
        #"""
        {
            "meals":
                [
                    {
                        "idMeal":"52795",
                        "strMeal":"Chicken Handi",
                        "strDrinkAlternate":null,
                        "strCategory":"Chicken",
                        "strArea":"Indian",
                        "strInstructions":"instructions here",
                        "strMealThumb":"https:\/\/www.themealdb.com\/images\/media\/meals\/wyxwsp1486979827.jpg",
                        "strTags":null,
                        "strYoutube":"https:\/\/www.youtube.com\/watch?v=IO0issT0Rmc",
                        "strIngredient1":"Chicken",
                        "strIngredient2":"Onion",
                        "strIngredient3":"Tomatoes",
                        "strIngredient4":"Garlic",
                        "strIngredient5":"Ginger paste",
                        "strIngredient6":"Vegetable oil",
                        "strIngredient7":"Cumin seeds",
                        "strIngredient8":"Coriander seeds",
                        "strIngredient9":"Turmeric powder",
                        "strIngredient10":"Chilli powder",
                        "strIngredient11":"Green chilli",
                        "strIngredient12":"Yogurt",
                        "strIngredient13":"Cream",
                        "strIngredient14":"fenugreek",
                        "strIngredient15":"Garam masala",
                        "strIngredient16":"Salt",
                        "strIngredient17":"",
                        "strIngredient18":"",
                        "strIngredient19":"",
                        "strIngredient20":"",
                        "strMeasure1":"1.2 kg",
                        "strMeasure2":"5 thinly sliced",
                        "strMeasure3":"2 finely chopped",
                        "strMeasure4":"8 cloves chopped",
                        "strMeasure5":"1 tbsp",
                        "strMeasure6":"\u00bc cup",
                        "strMeasure7":"2 tsp",
                        "strMeasure8":"3 tsp",
                        "strMeasure9":"1 tsp",
                        "strMeasure10":"1 tsp",
                        "strMeasure11":"2",
                        "strMeasure12":"1 cup",
                        "strMeasure13":"\u00be cup",
                        "strMeasure14":"3 tsp Dried",
                        "strMeasure15":"1 tsp",
                        "strMeasure16":"To taste",
                        "strMeasure17":"",
                        "strMeasure18":"",
                        "strMeasure19":"",
                        "strMeasure20":"",
                        "strSource":"",
                        "strImageSource":null,
                        "strCreativeCommonsConfirmed":null,
                        "dateModified":null
                    }
                ]
        }
        """#
