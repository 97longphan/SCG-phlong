//
//  Observable+Extension.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import RxSwift
import RxCocoa

public extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { _ in
            return Driver.empty()
        }
    }
}
