//
//  ListNewsUseCase.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import RxSwift
import Foundation

protocol ListNewsUseCaseDefault {
    func getListNews(_ page: Int) -> Observable<ListNewsModel>
}

class ListNewsUseCase: ListNewsUseCaseDefault {
    func getListNews(_ page: Int) -> Observable<ListNewsModel> {
        let request = AppUrlRequest.getListNews(page: page).urlRequest
        return URLSession.shared.rx.data(request: request!)
            .observe(on: MainScheduler.instance)
            .map { try JSONDecoder().decode(ListNewsModel.self, from: $0) }
    }
}
