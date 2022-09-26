//
//  SceneDelegate.swift
//  Pryaniky_TestTask
//
//  Created by Дмитрий Молодецкий on 25.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let networkService = NetworkService()
        let viewModel = MainTableViewModel(with: networkService)
        
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MainTableViewController(with: viewModel)
        window?.makeKeyAndVisible()
    }
}

