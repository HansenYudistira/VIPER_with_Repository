internal struct MealResponseDTO: Decodable {
    internal let idMeal: String?
    internal let strMeal: String?
    internal let strArea: String?
    internal let strInstructions: String?
    internal let strMealThumb: String?
    internal let strYoutube: String?
    internal let strIngredients: [String]?
    internal let strMeasure: [String]?

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strArea, strInstructions, strMealThumb, strYoutube
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decodeIfPresent(String.self, forKey: .idMeal)
        strMeal = try container.decodeIfPresent(String.self, forKey: .strMeal)
        strArea = try container.decodeIfPresent(String.self, forKey: .strArea)
        strInstructions = try container.decodeIfPresent(String.self, forKey: .strInstructions)
        strMealThumb = try container.decodeIfPresent(String.self, forKey: .strMealThumb)
        strYoutube = try container.decodeIfPresent(String.self, forKey: .strYoutube)

        let dynamicContainer = try decoder.container(keyedBy: DynamicCodingKeys.self)

        strIngredients = (1...20).compactMap { index in
            let key = DynamicCodingKeys(stringValue: "strIngredient\(index)")
            return key.flatMap { try? dynamicContainer.decodeIfPresent(String.self, forKey: $0) }
        }
        .filter { !$0.isEmpty }

        strMeasure = (1...20).compactMap { index in
            let key = DynamicCodingKeys(stringValue: "strIngredient\(index)")
            return key.flatMap { try? dynamicContainer.decodeIfPresent(String.self, forKey: $0) }
        }
        .filter { !$0.isEmpty }
    }
}

internal extension MealResponseDTO {
    func toDomain() -> MealModel {
        return MealModel(
            idMeal: idMeal ?? "",
            strMeal: strMeal ?? "",
            strArea: strArea ?? "",
            strInstructions: strInstructions ?? "",
            strMealThumb: strMealThumb ?? "",
            strYoutube: strYoutube ?? "",
            strIngredients: strIngredients ?? [],
            strMeasure: strMeasure ?? []
        )
    }
}

private struct DynamicCodingKeys: CodingKey {
    fileprivate var stringValue: String
    fileprivate var intValue: Int?

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}
