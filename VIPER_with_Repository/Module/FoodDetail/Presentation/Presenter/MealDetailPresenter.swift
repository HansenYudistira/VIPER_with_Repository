protocol MealDetailPresenterProtocol {
    func fetchDetailData() -> MealModel
}

internal class MealDetailPresenter {
    let mealModel: MealModel

    init(mealModel: MealModel) {
        self.mealModel = mealModel
    }
}

extension MealDetailPresenter: MealDetailPresenterProtocol {
    func fetchDetailData() -> MealModel {
        return mealModel
    }
}
