internal struct MealModel {
    let idMeal: String
    let strMeal: String
    let strArea: String
    let strInstructions: String
    let strMealThumb: String
    let strYoutube: String
    let strIngredients: [String]
    let strMeasure: [String]
}

extension MealModel {
    func toViewModel() -> MealViewModel {
        return MealViewModel(name: strMeal, area: strArea, imageURL: strMealThumb)
    }
}
