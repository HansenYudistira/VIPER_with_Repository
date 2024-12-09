internal struct MealModel {
    internal let idMeal: String
    internal let strMeal: String
    internal let strArea: String
    internal let strInstructions: String
    internal let strMealThumb: String
    internal let strYoutube: String
    internal let strIngredients: [String]
    internal let strMeasures: [String]
}

extension MealModel {
    internal func toViewModel() -> MealViewModel {
        return MealViewModel(name: strMeal, area: strArea, imageURL: strMealThumb)
    }
}
