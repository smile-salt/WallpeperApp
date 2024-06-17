//
//  ContainerViewController.swift
//  WallpaperApp
//
//  Created by school06 on 2024/06/02.
//

import UIKit

final class ContainerViewController: UIViewController {

    @IBOutlet private var footerTabView: FooterTabView! {
        didSet {
            footerTabView.delegate = self
        }
    }
    
    private var selectedTab: FooterTab = .home
    
    private lazy var homeViewController: HomeViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        add(childViewController: viewController)
        return viewController
    }()
    
    private lazy var tagSearchViewController: TagSearchViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "TagSearchViewController") as! TagSearchViewController
        add(childViewController: viewController)
        return viewController
    }()
    
    private lazy var appOverviewViewController: AppOverviewViewController = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "AppOverviewViewController") as! AppOverviewViewController
        add(childViewController: viewController)
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switchViewController(selectedTab: .home)
    }
    
    private func switchViewController(selectedTab: FooterTab) {
        switch selectedTab {
        case .home:
            remove(childViewController: tagSearchViewController)
            remove(childViewController: appOverviewViewController)
            add(childViewController: homeViewController)
        case .tagSearch:
            remove(childViewController: homeViewController)
            remove(childViewController: appOverviewViewController)
            add(childViewController: tagSearchViewController)
        case .appOverview:
            remove(childViewController: homeViewController)
            remove(childViewController: tagSearchViewController)
            add(childViewController: appOverviewViewController)
        }
        self.selectedTab = selectedTab
        view.bringSubviewToFront(footerTabView)
    }
    
    /// 子ViewControllerを追加する
    private func add(childViewController: UIViewController) {
        addChild(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = view.bounds
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParent: self)
    }

    /// 子ViewControllerを削除する
    private func remove(childViewController: UIViewController) {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
}

extension ContainerViewController : FooterTabViewDelegate {
    func footerTabView(_ footerTabView: FooterTabView, didSelectTab tab: FooterTab) {
        switchViewController(selectedTab: tab)
    }
}
