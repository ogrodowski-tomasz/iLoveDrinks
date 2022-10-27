//
//  SimpleDetailsTableViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import UIKit

/// TableViewCell with title with 2 labels: title and value.
///
/// This cell is supposed to be used in DetailsView at section with basic information about drink.
/// Possible use cases:
/// - Alcohol level
/// - Type of glass preferred to be used
/// - Category of drink
final class SimpleDetailsTableViewCell: UITableViewCell {

    static let identifier = "SimpleDetailsTableViewCell"
    
    private let rowTitleLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    private let rowContentLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(rowTitleLabel)
        contentView.addSubview(rowContentLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        rowTitleLabel.frame = CGRect(
            x: 5,
            y: 5,
            width: contentView.width / 3,
            height: contentView.height
        )
        rowContentLabel.frame = CGRect(
            x: rowTitleLabel.right,
            y: 5,
            width: contentView.width - (rowTitleLabel.width),
            height: contentView.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        rowTitleLabel.text = nil
        rowContentLabel.text = nil
    }
    
    public func configure(title: String, content: String) {
        rowTitleLabel.text = title
        rowContentLabel.text = content
        
        checkIfAlcoholic(content: content)
    }
    
    /// Whether the value provided indicates the alcohol content of the drink. Set the color of label's text based on that information
    ///
    /// If drink contains alcohol or is it optional method makes the label red, if it is specifically 'non alcoholic' then makes it green
    private func checkIfAlcoholic(content: String) {
        if content.lowercased() == "alcoholic" || content.lowercased() == "optional alcohol" {
            rowContentLabel.textColor = .systemRed
        } else if content.lowercased() == "non alcoholic" {
            rowContentLabel.textColor = .systemGreen
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
