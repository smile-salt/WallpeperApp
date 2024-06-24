//
//  HomeViewController.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/02.
//

import UIKit

private let reuseIdentifier = "Cell"

class HomeViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView! {
        didSet {
            collectionView.register(WallpaperCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
            collectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
            collectionView.backgroundColor = .white
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.contentInset = .init(top: 0, left: 0, bottom: 96, right: 0)
        }
    }
    
    var wallpapers: [UnsplashPhoto] = []
    let apiService = UnsplashAPI()
    let cellReuseIdentifier = "WallpaperCell"
    var selectedWallpaper: UnsplashPhoto?
    
    let pages = 5 // 画面内のタイル枚数

    override func viewDidLoad() {
        super.viewDidLoad()
        
        apiService.fetchLatestWallpapers(numberOfPages: pages, completion: { [weak self] (photos) in
            if let photos = photos {
                self?.wallpapers = photos
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }
        })
        
        let flowLayout = UICollectionViewFlowLayout()
        collectionView.collectionViewLayout = flowLayout
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
           let detailViewController = segue.destination as? WallpaperDetailViewController , let cell = sender as? WallpaperCollectionViewCell{
            detailViewController.wallpaper = selectedWallpaper
            detailViewController.photoImage = cell.getImage()
        }
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedWallpaper = wallpapers[indexPath.item]
        let selectedCell = collectionView.cellForItem(at: indexPath)
        performSegue(withIdentifier: "ShowDetail", sender: selectedCell)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! WallpaperCollectionViewCell
        let wallpaper = wallpapers[indexPath.item]
        cell.configure(with: wallpaper)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        header.configure(title: "新着写真")
        return header
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let topCellWidth = collectionView.bounds.width - 32
        let otherCellWidth = (topCellWidth - 16) / 2
        
        switch indexPath.row {
        case 0:
            return CGSize(width: topCellWidth, height: topCellWidth)
        default:
            return CGSize(width: otherCellWidth, height: otherCellWidth)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }
}
