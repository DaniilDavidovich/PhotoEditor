//
//  ViewController.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 4.11.24.
//

import UIKit


final class TabBarController: UITabBarController {
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupTabBarViewControllers()
    }
    
    
    // MARK: - Setups
    
    private func setupView() {
        self.tabBar.tintColor = .systemBlue
        let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
    
    private func setupTabBarViewControllers() {
        
        let photoEditorViewController = ViewControllerBuilder.getPhotoEditorViewController()
        let navigationPhotoEditorViewController = UINavigationController(rootViewController: photoEditorViewController)
        photoEditorViewController.tabBarItem = setupTabBarItem(title: "Editor",
                                                               image: "scribble.variable",
                                                               selectedImage: "scribble.variable")
        
        
        let settingViewController = ViewControllerBuilder.getSettingViewController()
        let navigationSettingViewController = UINavigationController(rootViewController: settingViewController)
        settingViewController.tabBarItem = setupTabBarItem(title: "Settings",
                                                           image: "gearshape.2",
                                                           selectedImage: "gearshape.2")
        
        let conrollers = [navigationPhotoEditorViewController, navigationSettingViewController]
        self.setViewControllers(conrollers, animated: true)
    }
    
    private func setupTabBarItem(title: String, image: String, selectedImage: String) -> UITabBarItem {
        let tabBarItem = UITabBarItem(title: title,
                     image: UIImage(named: image) ?? UIImage(systemName: image),
                     selectedImage: UIImage(named: selectedImage) ?? UIImage(systemName: selectedImage))
        return tabBarItem
    }
}
