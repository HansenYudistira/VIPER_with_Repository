import UIKit

protocol MealListViewProtocol: AnyObject {
    func showmeals(meals: [MealViewModel], uniqueArea: [String])
    func showError(_ error: String)
    func showLoading()
    func hideLoading()
}

internal class MealListViewController: UIViewController {
    internal let presenter: MealListPresenterProtocol

    private let loadingView: LoadingView
    private let mealListView: MealListView
    private var displayedMeals: [MealViewModel] = []
    private var uniqueArea: [String] = []

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
        configureNavigationBar()
        configureMealList()
        configureLoadingView()

        presenter.fetchSearchText("")
    }

    private func configureNavigationBar() {
        navigationItem.title = LocalizedKey.chooseYourMenu.localized
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.backgroundColor = .white
            navigationBar.isTranslucent = false
            navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        }
    }

    private func configureMealList() {
        view.addSubview(mealListView)

        NSLayoutConstraint.activate([
            mealListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            mealListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mealListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mealListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])

        mealListView.searchBar.delegate = self
        mealListView.filterCollection.delegate = self
        mealListView.filterCollection.dataSource = self
        mealListView.mealCollection.delegate = self
        mealListView.mealCollection.dataSource = self
    }

    private func configureLoadingView() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension MealListViewController: MealListViewProtocol {
    internal func showmeals(meals: [MealViewModel], uniqueArea: [String]) {
        self.uniqueArea = uniqueArea
        DispatchQueue.main.async {
            self.mealListView.filterCollection.reloadData()
        }
        resetFilters()
    }

    internal func showError(_ error: String) {
        let alert = UIAlertController(title: LocalizedKey.error.localized, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: LocalizedKey.ok.localized, style: .default))
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    internal func showLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = false
        }
    }

    internal func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView.isHidden = true
        }
    }
}

extension MealListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        resetFilters()
        presenter.fetchSearchText(searchBar.text ?? "")
    }

    private func resetFilters() {
        DispatchQueue.main.async {
            self.mealListView.filterCollection.visibleCells.forEach { cell in
                if let filterCell = cell as? FilterCollectionViewCell {
                    filterCell.resetState()
                }
            }
        }
        applyFilters()
    }
}

extension MealListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == mealListView.mealCollection {
            presenter.navigateToDetail(with: displayedMeals[indexPath.row])
        }
        return
    }
}

extension MealListViewController: UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mealListView.mealCollection {
            return displayedMeals.count
        } else if collectionView == mealListView.filterCollection {
            return uniqueArea.count
        }
        return 0
    }

    internal func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == mealListView.mealCollection {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: mealListView.mealIdentifier,
                for: indexPath
            ) as? MealCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: displayedMeals[indexPath.item])
            return cell
        } else if collectionView == mealListView.filterCollection {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: mealListView.filterIdentifier,
                for: indexPath
            ) as? FilterCollectionViewCell
            else {
                return UICollectionViewCell()
            }
            cell.configure(with: uniqueArea[indexPath.item])
            cell.delegate = self
            return cell
        }
        return UICollectionViewCell()
    }
}

extension MealListViewController: ButtonTappedDelegate {
    func toggle(_ sender: UIButton) {
        guard
            let area = sender.accessibilityLabel
        else {
            return
        }
        presenter.toggleFilter(for: area)
        applyFilters()
    }

    private func applyFilters() {
        displayedMeals = presenter.applyFilters()

        DispatchQueue.main.async {
            self.mealListView.mealCollection.reloadData()
        }
    }
}
