//
//  FooterButtonView.swift
//  WallpaperApp
//
//  Created by tdc on 2024/06/02.
//

import UIKit

enum FooterTab {
    case home
    case tagSearch
    case appOverview
}

protocol FooterTabViewDelegate : AnyObject {
    /// タブ選択時
    func footerTabView(_ footerTabView: FooterTabView, didSelectTab tab: FooterTab)
}

class FooterTabView: UIView {
    @IBOutlet private var shadowView: UIView!
    @IBOutlet private var contentView: UIView!
    
    @IBAction func didTapHome(_ sender: Any) {
        delegate?.footerTabView(self, didSelectTab: .home)
    }
    
    @IBAction func didTapTagSearch(_ sender: Any) {
        delegate?.footerTabView(self, didSelectTab: .tagSearch)
    }
    
    @IBAction func didTapAppOverview(_ sender: Any) {
        delegate?.footerTabView(self, didSelectTab: .appOverview)
    }
    
    weak var delegate: FooterTabViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        load()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        load()
        setup()
    }
    
    private func setup() {
        shadowView.layer.cornerRadius = frame.height / 2
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOpacity = 0.4
        shadowView.layer.shadowRadius = 8
        shadowView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        contentView.layer.cornerRadius = frame.height / 2
        contentView.layer.masksToBounds = true
    }

    func load() {
        if let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
}
