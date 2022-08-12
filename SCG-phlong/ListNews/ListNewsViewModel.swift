//
//  ListNewsViewModel.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import RxSwift
import RxCocoa

class ListNewsViewModel: BaseViewModel {
    private var navigator: ListNewsNavigatorDefault
    private var useCase: ListNewsUseCaseDefault
    private let hideLoading = BehaviorRelay<Bool>(value: true)
    
    init(navigator: ListNewsNavigatorDefault,
         useCase: ListNewsUseCaseDefault = ListNewsUseCase()) {
        self.navigator = navigator
        self.useCase = useCase
    }
}

extension ListNewsViewModel: ViewModelType {
    struct Input {
        let didLoadTrigger: Observable<Void>
    }
    
    struct Output {
        let articles: Observable<[Article]>
        let hideLoading: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let articles = input.didLoadTrigger
            .do(onNext: { [unowned self] in
                hideLoading.accept(false)
            }).flatMapLatest { [unowned self] in
                return self.useCase.getListNews(1)
            }.map {
                $0.articles
            } .do(onNext: { [unowned self] _ in
                hideLoading.accept(true)
            })
        
        return Output(articles: articles, hideLoading: hideLoading.asDriver())
    }
}
