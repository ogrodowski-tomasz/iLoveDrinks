//
//  IngredientsTableViewCollectionViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 25/10/2022.
//

import SDWebImage
import UIKit

final class IngredientsTableViewCollectionViewCell: UICollectionViewCell {
    static let identifier = "IngredientsTableViewCollectionViewCell"
    
    private let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person")
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .white
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = .black.withAlphaComponent(0.45)
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemGreen
        contentView.addSubview(drinkImageView)
        contentView.addSubview(label)
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 20
        contentView.backgroundColor = .systemYellow
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
    
    public func configure(with model: String) {
        label.text = model
        drinkImageView.sd_setImage(with: Endpoint.getIngredientsThumbnail(name: model).url)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        drinkImageView.image = nil
    }
}

