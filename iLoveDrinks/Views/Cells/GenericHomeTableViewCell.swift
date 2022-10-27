//
//  GenericHomeTableViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import RxSwift
import UIKit


/// Generic UITableViewCell that is build with collectionView. Its cells are squares.
///
/// Cell should be used on Home view with 3 sections:
/// - alcholic
/// - glass type
/// - category type
/// Cell also is equipped with RxSwift PublishSubjects which propagte information about touched CollectionView cell in order to navigate to Drinks view.
final class GenericHomeTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    static let identifier = "GenericHomeTableViewCell"
    
    private let disposeBag = DisposeBag()
    private var publishSubject = PublishSubject<String>()
    public var publishSubjectObservable: Observable<String> {
        return publishSubject.asObservable()
    }
    private var collectionView: UICollectionView?
    
    private var titles = [String]()
    private var images = [UIImage?]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        let size = 160
        layout.itemSize = CGSize(width: size, height: size)
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView?.register(GenericHomeTableViewCollectionViewCell.self, forCellWithReuseIdentifier: GenericHomeTableViewCollectionViewCell.identifier)
        collectionView?.showsHorizontalScrollIndicator = false
        
        guard let collectionView = collectionView else { return }
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func configure(titles: [String], images: [UIImage?]) {
        self.titles = titles
        self.images = images
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView?.frame = contentView.bounds
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenericHomeTableViewCollectionViewCell.identifier, for: indexPath) as? GenericHomeTableViewCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(title: titles[indexPath.row], image: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        publishSubject.onNext(titles[indexPath.row])
    }
}

final class GenericHomeTableViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "GenericHomeTableViewCollectionViewCell"
    
    private let drinkImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .black.withAlphaComponent(0.45)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemYellow
        contentView.addSubview(drinkImageView)
        contentView.addSubview(label)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // Center in cell
        drinkImageView.frame = contentView.bounds
        label.frame = contentView.bounds
    }
    
    public func configure(title: String, image: UIImage?) {
        label.text = title
        drinkImageView.image = image
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        drinkImageView.image = nil
    }
}
