//
//  DrinksViewController.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import RxSwift
import UIKit

class DrinksViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var collectionView: UICollectionView?
    
    var drinks = [Drink]()
    
    init(source: DrinksSourceFilter) {
        super.init(nibName: nil, bundle: nil)
        fetchDrinks(source: source)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCollectionView()
        
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
        self.collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        self.collectionView?.register(DrinkCollectionViewCell.self, forCellWithReuseIdentifier: DrinkCollectionViewCell.identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        
        guard let collectionView = collectionView else { return }
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func fetchDrinks(source: DrinksSourceFilter) {
        let resource = Resource<DrinksResponse>(endpoint: .getDrinks(source: source))

                URLRequest.load(resource: resource)
                    .subscribe(onNext: { [weak self] drinksResponse in
                        guard let drinks = drinksResponse?.drinks else { return }
                        self?.drinks = drinks
                        DispatchQueue.main.async {
                            self?.collectionView?.reloadData()
                        }
                    })
                    .disposed(by: disposeBag)
        
    }

}


extension DrinksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DrinkCollectionViewCell.identifier, for: indexPath) as! DrinkCollectionViewCell
        let drink = drinks[indexPath.row]
        cell.configure(text: drink.name, imageUrlAbsoluteString: drink.imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let vc = DetailsViewController(drink: drinks[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)        
    }
    
}
