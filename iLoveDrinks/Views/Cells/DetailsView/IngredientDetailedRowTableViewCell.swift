//
//  IngredientDetailedRowTableViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import SDWebImage
import UIKit

struct IngredientDetailedRowTableViewCellViewModel {
    let name: String
    let dose: String?
}

/// Cell showing Ingredient.
///
/// View contains:
/// - ingredientImageView: Ingredient's picture
/// - ingredient's name
/// - dose of ingredient
final class IngredientDetailedRowTableViewCell: UITableViewCell {
    
    static let identifier = "IngredientDetailedRowTableViewCell"
    
    private let ingredientImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "not provided"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 28, weight: .semibold)
        return label
    }()
    
    private let doseLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 23, weight: .medium)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(ingredientImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(doseLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let padding: CGFloat = 5
        let size = contentView.width / 3
        ingredientImageView.frame = CGRect(
            x: 0,
            y: padding,
            width: size,
            height: size
        )
        
        nameLabel.frame = CGRect(
            x: ingredientImageView.right + padding,
            y: padding,
            width: contentView.width - size,
            height: (ingredientImageView.height / 2) - padding
        )
        
        doseLabel.frame = CGRect(
            x: nameLabel.left,
            y: nameLabel.bottom + padding,
            width: contentView.width - size,
            height: (ingredientImageView.height / 2) - padding
        )
    }
    
    /// Configuring cell with name, dose and path to thumbnail of given ingredient.
    public func configure(with model: IngredientDetailedRowTableViewCellViewModel) {
        nameLabel.text = model.name
        doseLabel.text = model.dose
        let thumbnailUrl = Endpoint.getIngredientsThumbnail(name: model.name).url
        ingredientImageView.sd_setImage(with: thumbnailUrl)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        doseLabel.text = nil
        ingredientImageView.image = nil
    }
    
}
