import UIKit

protocol Router: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
}

internal class AppRouter: Router {
    internal var navigationController: UINavigationController
    private let window: UIWindow

    init(window: UIWindow, navigationController: UINavigationController) {
        self.window = window
        self.navigationController = navigationController
    }

    internal func start() {
        let firstRouter = FirstRouter(navigationController: navigationController)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        firstRouter.start()
    }
}
