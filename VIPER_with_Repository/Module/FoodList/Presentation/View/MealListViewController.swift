import UIKit

protocol MealListViewProtocol: AnyObject {
    func showmeals(_ meals: [MealViewModel])
    func showError(_ error: String)
    func showLoading()
    func hideLoading()
}

internal class MealListViewController: UIViewController {
    let presenter: MealListPresenterProtocol

    let loadingView: LoadingView
    let mealListView: MealListView

    init(presenter: MealListPresenterProtocol) {
        mealListView = MealListView()
        self.presenter = presenter
        self.loadingView = LoadingView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        navigationItem.title = "Choose Your Menu"
        view.addSubview(mealListView)

        NSLayoutConstraint.activate([
            mealListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mealListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mealListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mealListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        mealListView.searchBar.delegate = self

        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MealListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.fetchSearchText(searchBar.text ?? "")
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        presenter.fetchSearchText(searchBar.text ?? "")
    }
}

extension MealListViewController: MealListViewProtocol {
    func showmeals(_ meals: [MealViewModel]) {
        print("meals received in view: \(meals)")
    }

    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    func showLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
}
