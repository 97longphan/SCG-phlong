//
//  ListNewsNavigator.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import Foundation
protocol ListNewsNavigatorDefault {
    func goToNewsDetail(_ item: Article)
}

class ListNewsNavigator: BaseNavigator {}

extension ListNewsNavigator: ListNewsNavigatorDefault {
    func goToNewsDetail(_ item: Article) {
        let viewController = NewsDetailViewController()
        navigation.pushViewController(viewController, animated: true)
    }
}
