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
    private var currentSearchString: String?

    init(navigator: ListNewsNavigatorDefault,
         useCase: ListNewsUseCaseDefault = ListNewsUseCase()) {
        self.navigator = navigator
        self.useCase = useCase
    }
}

extension ListNewsViewModel: ViewModelType {
    struct Input {
        let didLoadTrigger: Observable<Void>
        let loadMoreTrigger: Observable<Void>
        let selectedCellTrigger: Driver<Article>
        let pullRefreshTrigger: Observable<Void>
        let searchTrigger: Observable<(String)>
    }
    
    struct Output {
        let articles: Observable<[Article]>
        let hideLoading: Driver<Bool>
        let error: Driver<Error>
    }

    
    func transform(input: Input) -> Output {
        let didSearchTrigger = input.searchTrigger
            .filter { !$0.isEmpty }
            .throttle(.seconds(5), latest: false, scheduler: MainScheduler.instance)
            .do(onNext: { [unowned self] in
                hideLoading.accept(false)
                article.removeAll()
                currentPage = 1
                currentSearchString = $0 })
            .flatMapLatest { [unowned self] in useCase.getListNews(page: currentPage, searchString: $0) }
        
        let didloadTrigger = Observable.merge(input.didLoadTrigger, input.pullRefreshTrigger)
            .do(onNext: { [unowned self] in
                hideLoading.accept(false)
                article.removeAll()
                currentPage = 1 })
            .flatMapLatest { [unowned self] in useCase.getListNews(page: currentPage, searchString: currentSearchString) }
        
        let loadMoreTrigger = input.loadMoreTrigger
            .do(onNext: { [unowned self] in currentPage += 1 })
            .flatMapLatest { [unowned self] in useCase.getListNews(page: currentPage, searchString: currentSearchString) }

        let news = Observable.merge(didloadTrigger, loadMoreTrigger, didSearchTrigger)
            .materialize()
            .share()
        
        input.selectedCellTrigger
            .drive(onNext: { [unowned self] in
                navigator.goToNewsDetail($0) })
            .disposed(by: disposeBag)
        
        let articles = news
            .do(onNext: { [unowned self] in
                hideLoading.accept(true)
                self.article.append(contentsOf: $0.element?.articles ?? []) })
            .map { [unowned self] _ in self.article }
        
        let error = news
            .do(onNext: { [unowned self] _ in hideLoading.accept(true) })
            .compactMap{ $0.error }
        
        return Output(articles: articles,
                      hideLoading: hideLoading.asDriver(),
                      error: error.asDriverOnErrorJustComplete())
    }
}
