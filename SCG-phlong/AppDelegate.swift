//
//  AppDelegate.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigation = UINavigationController()
        let listNavigator = ListNewsNavigator(navigation: navigation)
        let listNewsViewModel = ListNewsViewModel(navigator: listNavigator)
        let listNewsViewController = ListNewsViewController(viewModel: listNewsViewModel)
        
        navigation.viewControllers = [listNewsViewController]
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        return true
    }


}

