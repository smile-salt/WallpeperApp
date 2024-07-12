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
        
        if let jaTitle = wallpaper?.alternativeSlug?["ja"],
           let titleWithoutSuffix = jaTitle.components(separatedBy: "-").first {
            self.title = titleWithoutSuffix
        } else if let altDescription = wallpaper?.altDescription {
            self.title = altDescription
        } else {
            self.title = ""
        }
        
        imageView.image = photoImage
        imageView.isUserInteractionEnabled = true
        let photoTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPhotoImage))
        imageView.addGestureRecognizer(photoTapGesture)
        
        guard let wallpaper = wallpaper else {
            return
        }
        
        let profileURL = URL(string: "https://unsplash.com/ja/@\(wallpaper.user.username)")!
        
        let attributedString = NSAttributedString(string: wallpaper.user.username, attributes: [.link: profileURL])
        self.userNameLabel.attributedText = attributedString
        self.userNameLabel.text = wallpaper.user.username
        self.locationLabel.text = wallpaper.user.location
        print("ユーザーの名前\(wallpaper.user.username)")
        
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
        
        let profileVC = AppOverviewViewController()
        profileVC.profileURL = url
        present(profileVC, animated: true)
    }
    
    @objc func tappedPhotoImage() {
        performSegue(withIdentifier: "ShowPhotoDetailModal", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPhotoDetailModal",
           let detailViewController = segue.destination as? PhotoDetailViewController {
            detailViewController.photoImage = photoImage
        }
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
