//
//  DetailsViewController.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import RxSwift
import UIKit

/*
 View's sections:
 - Large image with title on it
 - Cells with information about:
    > Alcoholic value
    > Glass
    > Category
 - Ingredients with dose
 - Instructions
 */

struct DetailsViewModel {
    let title: String
    let content: String
}

class DetailsViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let drink: Drink
    
    private var details: Details?
    
    private var models = [DetailsViewModel]()
    private var ingredientsSectionViewModels = [IngredientDetailedRowTableViewCellViewModel]()
    
    private var favoriteDrinksService: any FavoriteDrinksDataServicable
    private var isFavorite = false
    
    init(
        drink: Drink,
        favoriteDrinksService: any FavoriteDrinksDataServicable = FavoriteDrinksDataService.shared
    ) {
        self.drink = drink
        self.favoriteDrinksService = favoriteDrinksService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(DrinkPresentationTableViewCell.self, forCellReuseIdentifier: DrinkPresentationTableViewCell.identifier)
        tableView.register(SimpleDetailsTableViewCell.self, forCellReuseIdentifier: SimpleDetailsTableViewCell.identifier)
        tableView.register(IngredientDetailedRowTableViewCell.self, forCellReuseIdentifier: IngredientDetailedRowTableViewCell.identifier)
        tableView.register(InstructionsTableViewCell.self, forCellReuseIdentifier: InstructionsTableViewCell.identifier)
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = false
        let uiBarRightButton = UIBarButtonItem(image: configureFavoriteButton(), style: .plain, target: self, action: #selector(didTapAddToFavoritesButton))
        uiBarRightButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = uiBarRightButton
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchDetails(for: drink)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureFavoriteButton() -> UIImage? {
        if favoriteDrinksService.isDrinkFavorite(drink: drink) {
            return UIImage(systemName: "heart.fill")
        } else {
            return UIImage(systemName: "heart")
        }
    }
    
    @objc
    private func didTapAddToFavoritesButton() {
        isFavorite.toggle()
        navigationItem.rightBarButtonItem?.image = configureFavoriteButton()
        favoriteDrinksService.updateFavorites(drink: drink)
        navigationItem.rightBarButtonItem?.image = configureFavoriteButton()
    }
    
    private func configureModels() {
        guard var details = self.details else { return }
        self.models.append(DetailsViewModel(title: "Alcoholic", content: details.alcoholic))
        self.models.append(DetailsViewModel(title: "Glass", content: details.glass))
        self.models.append(DetailsViewModel(title: "Category", content: details.category))
        
        let ingredients = details.ingredients.compactMap { $0 }
                
        for i in 0..<ingredients.count {
            self.ingredientsSectionViewModels.append(IngredientDetailedRowTableViewCellViewModel(name: ingredients[i], dose: details.doses[i]))
        }
    }

    private func fetchDetails(for drink: Drink) {
        let resource = Resource<DetailsResponse>(endpoint: .getDetails(drinkId: drink.id))

                URLRequest.load(resource: resource)
                    .subscribe(onNext: { [weak self] detailsResponse in
                        guard let details = detailsResponse?.details.first else { return }
                        self?.details = details
                        self?.configureModels()
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    })
                    .disposed(by: disposeBag)
    }
}

extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            // Image
            return 1
        case 1:
            // Basic info
            return models.count
        case 2:
            // Ingredients
            return ingredientsSectionViewModels.count
        case 3:
            // Instructions
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return view.width
        case 2:
            return (view.width / 3) + 10
        case 3:
            return 250
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: DrinkPresentationTableViewCell.identifier, for: indexPath) as? DrinkPresentationTableViewCell else { return UITableViewCell() }
            cell.configure(with: drink.name, imagePath: drink.imageURL)
            cell.drinkAddedToFavoriteSubjectObservable
                .subscribe(onNext: { addingToFavorite in
                    print("Changed current state of drink in favorite container: \(addingToFavorite)")
                    
                })
                .disposed(by: disposeBag)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SimpleDetailsTableViewCell.identifier, for: indexPath) as? SimpleDetailsTableViewCell else { return UITableViewCell() }
            let model = models[indexPath.row]
            cell.configure(title: model.title, content: model.content)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientDetailedRowTableViewCell.identifier, for: indexPath) as? IngredientDetailedRowTableViewCell else { return UITableViewCell() }
            let model = ingredientsSectionViewModels[indexPath.row]
            cell.configure(with: model)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InstructionsTableViewCell.identifier, for: indexPath) as? InstructionsTableViewCell else { return UITableViewCell() }
            cell.configure(with: details?.instructions ?? "Non provided")
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .systemBlue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            // There will be no title, just drink's photo with name
            return nil
        case 1:
            return "\(drink.name)'s basic information"
        case 2:
            return "Ingredients (\(ingredientsSectionViewModels.count))"
        case 3:
            return "Instructions"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    private func combinedIngredients() -> [String : String] {
        guard var details = details else { return [:] }
        var output = [String : String]()
        
        let unwrappedIngredients = details.ingredients.compactMap { $0 }
        let unwrappedDoses = details.doses.compactMap { $0 }
        
        guard unwrappedDoses.count == unwrappedIngredients.count else { return output }
        
        for i in 0..<unwrappedIngredients.count {
            output[unwrappedIngredients[i]] = unwrappedDoses[i]
        }
        
        return output
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
