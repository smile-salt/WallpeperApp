//
//  TagSearchViewController.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/02.
//

import UIKit

enum ColorTag: String, CaseIterable {
    case red
    case blue
    case green
    case yellow
    case white
    case black
}

final class TagSearchViewController: UIViewController {

    private var wallpapers: [UnsplashPhoto] = []
    private let apiService = UnsplashAPIService()
    private var selectedTag: ColorTag = .red
    private var selectedWallpaper: UnsplashPhoto?
    
    let pages = 5 // 画面内のタイル枚数
    
    @IBOutlet private var tagCollectionView: UICollectionView!  {
        didSet {
            tagCollectionView.register(UINib(nibName: "TagCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TagCollectionViewCell")
            tagCollectionView.backgroundColor = .white
            tagCollectionView.delegate = self
            tagCollectionView.dataSource = self
        }
    }
    
    @IBOutlet private var wallpaperCollectionView: UICollectionView! {
        didSet {
            wallpaperCollectionView.register(WallpaperCollectionViewCell.self, forCellWithReuseIdentifier: "WallpaperCollectionViewCell")
            wallpaperCollectionView.backgroundColor = .white
            wallpaperCollectionView.delegate = self
            wallpaperCollectionView.dataSource = self
            wallpaperCollectionView.contentInset = .init(top: 0, left: 0, bottom: 96, right: 0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
        wallpaperCollectionView.collectionViewLayout = flowLayout
        
        searchWallpapers(colorTag: .red)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
           let detailViewController = segue.destination as? WallpaperDetailViewController , let cell = sender as? WallpaperCollectionViewCell {
            detailViewController.wallpaper = selectedWallpaper
            detailViewController.photoImage = cell.getImage()
        }
    }
    
    private func searchWallpapers(colorTag: ColorTag){
        apiService.searchWallpapersByColor(numberOfPages: pages, colorTag: colorTag) { [weak self] photos in
            if let photos = photos {
                self?.wallpapers = photos
                DispatchQueue.main.async {
                    self?.wallpaperCollectionView.reloadData()
                }
            }
        }
    }
}

extension TagSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tagCollectionView {
            let tag = ColorTag.allCases[indexPath.row]
            selectedTag = tag
            tagCollectionView.reloadData()
            searchWallpapers(colorTag: tag)
        } else {
            selectedWallpaper = wallpapers[indexPath.item]
            let selectedCell = collectionView.cellForItem(at: indexPath)
            performSegue(withIdentifier: "ShowDetail", sender: selectedCell)
        }
    }
}

extension TagSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tagCollectionView {
            return ColorTag.allCases.count
        } else {
            return wallpapers.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tagCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCollectionViewCell", for: indexPath) as! TagCollectionViewCell
            let tag = ColorTag.allCases[indexPath.row]
            cell.configure(with: tag, isSelected: selectedTag == tag)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WallpaperCollectionViewCell", for: indexPath) as! WallpaperCollectionViewCell
            let wallpaper = wallpapers[indexPath.row]
            cell.configure(with: wallpaper)
            return cell
        }
    }
}

extension TagSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == wallpaperCollectionView {
            let topCellWidth = collectionView.bounds.width - 32
            let otherCellWidth = (topCellWidth - 16) / 2
            
            switch indexPath.row {
            case 0:
                return CGSize(width: topCellWidth, height: topCellWidth)
            default:
                return CGSize(width: otherCellWidth, height: otherCellWidth)
            }
        } else {
            return .zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}
