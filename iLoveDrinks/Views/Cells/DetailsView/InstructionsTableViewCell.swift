//
//  InstructionsTableViewCell.swift
//  iLoveDrinks
//
//  Created by Tomasz Ogrodowski on 26/10/2022.
//

import UIKit

/// Cell with instructions to prepare given drink. Configuring cell is possible with built configure(with:) method.
final class InstructionsTableViewCell: UITableViewCell {
    
    static let identifier = "InstructionsTableViewCell"
    
    private let instructionsLabel: UILabel = {
       let label = UILabel()
        label.textAlignment = .left
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = .systemFont(ofSize: 25, weight: .thin)
        label.insetsLayoutMarginsFromSafeArea = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(instructionsLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        instructionsLabel.frame = CGRect(x: 10, y: 10, width: contentView.width - 20, height: contentView.height)
        instructionsLabel.sizeToFit()
        
    }
    
    /// Configure cell with instruction of how to prepare drink
    public func configure(with text: String) {
        instructionsLabel.text = text
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        instructionsLabel.text = nil
    }
    
}
