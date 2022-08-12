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
    private var article = [Article]()
    private var currentPage = 1
    init(navigator: ListNewsNavigatorDefault,
         useCase: ListNewsUseCaseDefault = ListNewsUseCase()) {
        self.navigator = navigator
        self.useCase = useCase
    }
}

extension ListNewsViewModel: ViewModelType {
    struct Input {
        let loadNews: Observable<Bool>
        let selectedCellTrigger: Driver<Article>
    }
    
    struct Output {
        let articles: Observable<[Article]>
        let hideLoading: Driver<Bool>
        let error: Driver<Error>
    }
    
    func transform(input: Input) -> Output {
        let loadNews = input.loadNews
            .do(onNext: { [unowned self] _ in hideLoading.accept(false) })
            .map { [unowned self] in self.currentPage = $0 ? currentPage + 1 : currentPage }
            .flatMapLatest { [unowned self] in self.useCase.getListNews(currentPage) }
            .materialize()
            .share()
        
        input.selectedCellTrigger
            .drive(onNext: { [unowned self] in
                navigator.goToNewsDetail($0)
            }).disposed(by: disposeBag)
        
        let articles = loadNews
            .do(onNext: { [unowned self] in
                hideLoading.accept(true)
                self.article.append(contentsOf: $0.element?.articles ?? []) })
            .map { [unowned self] _ in self.article }
        
        let error = loadNews
            .do(onNext: { [unowned self] _ in hideLoading.accept(true) })
            .compactMap{ $0.error }
        
        return Output(articles: articles, hideLoading: hideLoading.asDriver(), error: error.asDriverOnErrorJustComplete())
    }
}
