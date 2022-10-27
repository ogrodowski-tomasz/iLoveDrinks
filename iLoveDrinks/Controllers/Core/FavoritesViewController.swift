//
//  FavoritesViewController.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import RxSwift
import UIKit

class FavoritesViewController: UIViewController {
    // MARK: RxSwift properties
    private let disposeBag = DisposeBag()
    
    // MARK: View components
    private var collectionView: UICollectionView?
    
    // MARK: Properties
    private var favoriteDrinksService: any FavoriteDrinksDataServicable
    private var drinks: [Drink] = []
    
    // MARK: Inits
    init(
        favoriteDrinksService: any FavoriteDrinksDataServicable = FavoriteDrinksDataService.shared
    ) {
        self.favoriteDrinksService = favoriteDrinksService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.favoriteDrinksService = FavoriteDrinksDataService.shared
        
        super.init(coder: aDecoder)
    }
    
    // MARK: View's lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        configureInitialModels()
        
        favoriteDrinksService.savedFavoriteDrinksSubjectObservable
            .subscribe(onNext: { [weak self] drinks in
                guard let self = self else { return }
                self.drinks = self.mappingFavoriteDrinkModels(drinks)
                self.collectionView?.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 10, right: 5)
        let width = (view.width - 20)/2
        layout.itemSize = CGSize(width: width, height: width + 70)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        self.collectionView?.register(DrinkCollectionViewCell.self, forCellWithReuseIdentifier: DrinkCollectionViewCell.identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func configureInitialModels() {
        self.drinks = mappingFavoriteDrinkModels(favoriteDrinksService.savedEntities)
    }
    
    private func mappingFavoriteDrinkModels(_ drinks: [FavoriteDrink]) -> [Drink] {
        return drinks.map { favoriteDrink -> Drink in
            return Drink(name: favoriteDrink.name ?? "", imageURL: favoriteDrink.imagePath ?? "", id: favoriteDrink.id ?? "")
        }
    }
}

// MARK: UICollectionViewDelegate and UICollectionViewDataSource protocols implementation
extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCollectionViewCell.identifier, for: indexPath) as? DrinkCollectionViewCell else { return UICollectionViewCell() }
        let drink = drinks[indexPath.row]
        cell.configure(text: drink.name, imageUrlAbsoluteString: drink.imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let tappedDrink = drinks[indexPath.row]
        let vc = DetailsViewController(drink: tappedDrink)
        navigationController?.pushViewController(vc, animated: true)
    }
}
