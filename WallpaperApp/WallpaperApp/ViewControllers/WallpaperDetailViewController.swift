//
//  WallpaperDetailViewController.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/02.
//

import Foundation
import UIKit

class WallpaperDetailViewController: UIViewController {
    var wallpaper: UnsplashPhoto?
    var photoImage: UIImage?
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var userNameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var updateAtLabel: UILabel!
    
    @IBOutlet weak var detailInfomationStackView: UIStackView!
    @IBOutlet weak var photoInfoLabel: UILabel!
    
    var isPhotoViewing = false
    
    init(wallpaper: UnsplashPhoto) {
        self.wallpaper = wallpaper
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        imageView.image = photoImage
        imageView.isUserInteractionEnabled = true
        let photoTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage))
        imageView.addGestureRecognizer(photoTapGesture)
        
        view.isUserInteractionEnabled = true
        let viewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedView))
        view.addGestureRecognizer(viewTapGesture)
        
        guard let wallpaper = wallpaper else {
            return
        }
        
        let profileURL = URL(string: "https://unsplash.com/ja/@\(wallpaper.user.username)")!
        
        let attributedString = NSAttributedString(string: wallpaper.user.username, attributes: [.link: profileURL])
        self.userNameLabel.attributedText = attributedString
        self.userNameLabel.text = wallpaper.user.username
        self.locationLabel.text = wallpaper.user.location
        
        let date = wallpaper.updatedAt.toDate(format: "yyyy-MM-dd'T'HH:mm:ssZ")
        let dateString = date?.toString(format: "yyyy年MM月dd日")
        self.updateAtLabel.text = dateString
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
        self.userNameLabel.isUserInteractionEnabled = true
        self.userNameLabel.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func openProfile(_ gesture: UITapGestureRecognizer) {
        guard let url = (gesture.view as? UILabel)?.attributedText?.attribute(.link, at: 0, effectiveRange: nil) as? URL else {
            return
        }
        UIApplication.shared.open(url)
    }
    
    @objc func tappedPhotoImage() {
        togglePhotoViewingStyle()
    }
    
    @objc func tappedView() {
        // 詳細ビュー状態の解除は写真以外の箇所でも反応する必要があるため実装
        if isPhotoViewing {
            togglePhotoViewingStyle()
        }
    }
    
    
    func togglePhotoViewingStyle() {
        if isPhotoViewing {
            detailInfomationStackView.isHidden = false
            photoInfoLabel.isHidden = false
            navigationItem.hidesBackButton = false
            UIView.animate(withDuration: 0.2) {
                self.view.backgroundColor = .white
            }
        } else {
            detailInfomationStackView.isHidden = true
            photoInfoLabel.isHidden = true
            navigationItem.hidesBackButton = true
            UIView.animate(withDuration: 0.3) {
                // 指定のカラーコード
                self.view.backgroundColor = UIColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)
            }
        }
        
        isPhotoViewing = !isPhotoViewing
    }
    
    
    
}

private extension String {
    func toDate(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: self) ?? nil
    }
}

private extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
