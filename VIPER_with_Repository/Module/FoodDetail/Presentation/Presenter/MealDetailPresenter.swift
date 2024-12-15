protocol MealDetailPresenterProtocol {
    func fetchDetailData() -> MealModel
}

internal class MealDetailPresenter {
    private let mealModel: MealModel

    init(mealModel: MealModel) {
        self.mealModel = mealModel
    }
}

extension MealDetailPresenter: MealDetailPresenterProtocol {
    internal func fetchDetailData() -> MealModel {
        return mealModel
    }
}
