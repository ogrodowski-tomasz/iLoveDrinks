//
//  DrinkCollectionViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import RxSwift
import SDWebImage
import UIKit

class DrinkCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DrinkCollectionViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "<Drink name here>"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 17, weight: .medium)
        return label
    }()
    
    private let drinkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "glass2")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(drinkImageView)
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = UIColor.black
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        drinkImageView.frame = CGRect(x: 0, y: 0, width: contentView.width, height: contentView.width)
        let gradient = CAGradientLayer()
        gradient.frame = drinkImageView.bounds
        let startColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0).cgColor
        let endColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        gradient.colors = [startColor, startColor, startColor, startColor, endColor]
        drinkImageView.layer.insertSublayer(gradient, at: 0)
        nameLabel.frame = CGRect(x: 5, y: drinkImageView.bottom + 2, width: contentView.width - 10, height: contentView.height - drinkImageView.height)
    }
    
    
    /// Set cell's view with drink's name and path to its thumbnail image
    /// - Parameters:
    ///   - text: drink's name
    ///   - imageUrlAbsoluteString: string path to drink's image
    public func configure(text: String, imageUrlAbsoluteString: String) {
        nameLabel.text = text
        drinkImageView.sd_setImage(with: URL(string: imageUrlAbsoluteString))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        drinkImageView.image = nil
    }
    
}
