//
//  SceneDelegate.swift
//  PhotoEditor
//
//  Created by Daniil Davidovich on 4.11.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarController()
        
        if let controllers = tabBarController.viewControllers, !controllers.isEmpty {
            tabBarController.selectedIndex = 0
        }
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
    }
}

