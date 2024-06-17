//
//  SectionHeader.swift
//  WallpaperApp
//
//  Created by school on 2024/06/09.
//

import UIKit

final class SectionHeader: UICollectionReusableView {

    @IBOutlet private var titleLabel: UILabel!
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
