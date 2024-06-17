//
//  TagCollectionViewCell.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/05.
//

import UIKit

final class TagCollectionViewCell: UICollectionViewCell {

    @IBOutlet private var tagLabel: UILabel!
    @IBOutlet private var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        borderView.layer.cornerRadius = 4
        borderView.layer.borderColor = UIColor.black.cgColor
        borderView.layer.borderWidth = 1
    }
    
    func configure(with tag: ColorTag, isSelected: Bool) {
        tagLabel.text = tag.rawValue
        tagLabel.textColor = isSelected ? .white : .black
        borderView.backgroundColor = isSelected ? .black : .white
    }
}
