//
//  ListNewsViewModelTest.swift
//  SCG-phlongTests
//
//  Created by phlong on 13/08/2022.
//
@testable import SCG_phlong
import XCTest
import RxSwift
import RxTest

class ListNewsViewModelTest: XCTestCase {
    private var viewModel: ListNewsViewModel!
    private var navigator: ListNewsNavigatorMock!
    private var useCase: ListNewsUseCaseMock!
    private var input: ListNewsViewModel.Input!
    private var output: ListNewsViewModel.Output!
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    
    //input
    private let didLoadTrigger = PublishSubject<Void>()
    private let loadMoreTrigger = PublishSubject<Void>()
    private let selectedTrigger = PublishSubject<Article>()
    private let pullRefreshTrigger = PublishSubject<Void>()
    private let searchTrigger = PublishSubject<String>()
    
    //output
    private var articlesOutput: TestableObserver<[Article]>!
    private var hideLoadingOutput: TestableObserver<Bool>!
    private var errorOutput: TestableObserver<Error>!

    override func setUp() {
        super.setUp()
        navigator = ListNewsNavigatorMock()
        useCase = ListNewsUseCaseMock()
        viewModel = ListNewsViewModel(navigator: navigator, useCase: useCase)
        
        input = ListNewsViewModel.Input(didLoadTrigger: didLoadTrigger,
                                        loadMoreTrigger: loadMoreTrigger,
                                        selectedCellTrigger: selectedTrigger.asDriverOnErrorJustComplete(),
                                        pullRefreshTrigger: pullRefreshTrigger,
                                        searchTrigger: searchTrigger)
        
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
        output = viewModel.transform(input: input)
        
        articlesOutput = scheduler.createObserver([Article].self)
        hideLoadingOutput = scheduler.createObserver(Bool.self)
        errorOutput = scheduler.createObserver(Error.self)
        
        output.articles.subscribe(articlesOutput).disposed(by: disposeBag)
        output.hideLoading.drive(hideLoadingOutput).disposed(by: disposeBag)
        output.error.drive(errorOutput).disposed(by: disposeBag)
    }
    
    private func startTrigger(didLoad: Recorded<Event<Void>>? = nil,
                              loadMore: Recorded<Event<Void>>? = nil,
                              search: Recorded<Event<String>>? = nil,
                              pullRefresh: Recorded<Event<Void>>? = nil,
                              selected: Recorded<Event<Article>>? = nil) {
        if let didLoad = didLoad {
            scheduler.createColdObservable([didLoad])
                .bind(to: didLoadTrigger)
                .disposed(by: disposeBag)
        }
        
        if let loadMore = loadMore {
            scheduler.createColdObservable([loadMore])
                .bind(to: loadMoreTrigger)
                .disposed(by: disposeBag)
        }
        
        if let search = search {
            scheduler.createColdObservable([search])
                .bind(to: searchTrigger)
                .disposed(by: disposeBag)
        }
        
        if let pullRefresh = pullRefresh {
            scheduler.createColdObservable([pullRefresh])
                .bind(to: pullRefreshTrigger)
                .disposed(by: disposeBag)
        }
        
        if let selected = selected {
            scheduler.createColdObservable([selected])
                .bind(to: selectedTrigger)
                .disposed(by: disposeBag)
        }
        
        scheduler.start()
    }
    
    func test_didLoadTrigger_getListNews() {
        startTrigger(didLoad: .next(0, ()))
        
        XCTAssertEqual(1, articlesOutput.events.last?.value.element?.count)
        XCTAssertEqual(useCase.didCallGetListNews, true)
    }
    
    func test_loadMoreTrigger_getListNews() {
        startTrigger(didLoad: .next(0, ()),
                     loadMore: .next(0, ()))
        
        XCTAssertEqual(articlesOutput.events.last?.value.element?.count, 2)
        XCTAssertEqual(useCase.didCallGetListNews, true)
        XCTAssertEqual(articlesOutput.events.last?.value.element?.last?.title, "title1")
    }
    
    func test_searchTrigger_getListNews() {
        useCase.isSearch = true
        
        startTrigger(didLoad: .next(0, ()),
                     search: .next(0, ("search")))
        
        
        XCTAssertEqual(articlesOutput.events.last?.value.element?.count, 1)
        XCTAssertEqual(useCase.didCallGetListNews, true)
        XCTAssertEqual(articlesOutput.events.last?.value.element?.last?.author, "searchAuthor1")
    }
    
    func test_selectTrigger_goToDetail() {
        startTrigger(selected: .next(0, (Article(author: "selected author"))))
        
        XCTAssertEqual(navigator.didCallGoToNewsDetail, true)
        XCTAssertEqual(navigator.itemSelected.author, "selected author")
    }
    
    func test_pullRefresh_goListNews() {
        useCase.isPullRefresh = true
        
        startTrigger(didLoad: .next(0, ()),
                     pullRefresh: .next(0, ()))
        
        XCTAssertEqual(articlesOutput.events.last?.value.element?.count, 1)
        XCTAssertEqual(useCase.didCallGetListNews, true)
        XCTAssertEqual(articlesOutput.events.last?.value.element?.last?.author, "pullRFAuthor1")
    }
    
    func test_request_api_error() {
        useCase.isRequestError = true
        
        startTrigger(didLoad: .next(0, ()))
        XCTAssertEqual(useCase.didCallGetListNews, true)
        XCTAssertEqual(errorOutput.events.first?.value.element?.localizedDescription, "Error from network")
    }

}
