//
//  ListNewsNavigator.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import Foundation
protocol ListNewsNavigatorDefault {
    func goToNewsDetail()
}

class ListNewsNavigator: BaseNavigator {}

extension ListNewsNavigator: ListNewsNavigatorDefault {
    func goToNewsDetail() {
        
    }
}
