//
//  DrinkPresentationTableViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import RxSwift
import SDWebImage
import UIKit


/// Cell with drink's thumbnail and name.
final class DrinkPresentationTableViewCell: UITableViewCell {
    
    static let identifier = "DrinkPresentationTableViewCell"
    
    private var drinkAddedToFavoriteSubject = PublishSubject<Bool>()
    var drinkAddedToFavoriteSubjectObservable: Observable<Bool> {
        return drinkAddedToFavoriteSubject.asObservable()
    }
    
    private var isFavorite: Bool = false
    
    private let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 23, weight: .medium)
        return label
    }()
    
    private let addToFavoritesButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "heart"), for: .normal)
        button.tintColor = .systemRed
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(drinkImageView)
        contentView.addSubview(nameLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drinkImageView.frame = contentView.bounds
        
        let gradient = CAGradientLayer()
        gradient.frame = drinkImageView.bounds
        let startColor = UIColor.black.withAlphaComponent(0).cgColor
        let endColor = UIColor.black.withAlphaComponent(1).cgColor
        gradient.colors = [startColor, startColor, startColor, endColor]
        drinkImageView.layer.insertSublayer(gradient, at: 0)
        
        nameLabel.frame = CGRect(x: 5, y: drinkImageView.bottom - 150, width: contentView.width - 10, height: 150)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    /// Set cell with drink's name and path for its thumbnail image
    /// - Parameters:
    ///   - text: drink's name
    ///   - imagePath: path to thumbnail image as String
    public func configure(with text: String, imagePath: String) {
        nameLabel.text = text
        drinkImageView.sd_setImage(with: URL(string: imagePath))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        drinkImageView.image = nil
    }
}
