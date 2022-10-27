//
//  IngredientsTableViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import RxSwift
import UIKit

/// TableViewCell with UICollectionView inside.
///
/// Cell contains cards with ingredients. Image and Name is provided within this cell.
/// Cell also contains RxSwift subjects which makes possible to navigate to Drinks based on selected ingredient. Reactive cells populate ingredient's name.
final class IngredientsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let identifier = "IngredientsTableViewCell"
    
    private var collectionView: UICollectionView?
    
    private let disposeBag = DisposeBag()
    private var ingredientSubject = PublishSubject<String>()
    public var ingredientSubjectObservable: Observable<String> {
        return ingredientSubject.asObservable()
    }
    
    private var models = [String]()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
        
        setupCollectionView()
        populateIngredients()
    }
    
    /// Setting up collection view.
    ///
    /// This process contains creating UICollectionViewFlowLayout, then creating collectionView itself.
    /// Later collectionView's delegates and data source is assigned
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let size = 150
        layout.itemSize = CGSize(width: size, height: 200)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        // Registering cells
        self.collectionView?.register(IngredientsTableViewCollectionViewCell.self, forCellWithReuseIdentifier: IngredientsTableViewCollectionViewCell.identifier)
        
        collectionView?.showsHorizontalScrollIndicator = false
        
        guard let collectionView = collectionView else { return }
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    /// Fetch data from network and form ViewModels based on response.
    private func populateIngredients() {
        let resource = Resource<IngredientsResponse>(endpoint: .getIngredients)
        
                URLRequest.load(resource: resource)
                    .subscribe(onNext: { [weak self] ingredientsResponse in
                        guard let ingredients = ingredientsResponse?.ingredients else { return }
                        self?.models = ingredients.map { $0.name }
                        DispatchQueue.main.async {
                            self?.collectionView?.reloadData()
                        }
                    })
                    .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = contentView.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: IngredientsTableViewCollectionViewCell.identifier, for: indexPath) as? IngredientsTableViewCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: models[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        ingredientSubject.onNext(models[indexPath.row])
    }
    
}



