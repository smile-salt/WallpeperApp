//
//  PhotoDetailViewController.swift
//  WallpaperApp
//
//  Created by user on 2024/06/19.
//

import UIKit

class PhotoDetailViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var photoImage: UIImage?
    var wallaper: UnsplashAPI?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = photoImage {
            imageView.image = image
        }
        setupScrollView()
        setupTapGestureRecognizer()
    }
    
    private func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.5
    }
    
    private func setupTapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: imageView)
        
        let currentScale = scrollView.zoomScale
        let newScale = currentScale == 1.0 ? scrollView.maximumZoomScale : scrollView.minimumZoomScale
        
        let zoomRect = zoomRectForScale(scale: newScale, center: tapLocation)
        scrollView.zoom(to: zoomRect, animated: true)
    }

    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let size = CGSize(width: scrollView.bounds.size.width / scale,
                          height: scrollView.bounds.size.height / scale)
        let origin = CGPoint(x: center.x - (size.width / 2.0),
                             y: center.y - (size.height / 2.0))
        return CGRect(origin: origin, size: size)
    }

}


extension PhotoDetailViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
