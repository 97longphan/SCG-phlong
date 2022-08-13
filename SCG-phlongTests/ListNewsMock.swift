//
//  ListNewsNavigatorMock.swift
//  SCG-phlongTests
//
//  Created by phlong on 13/08/2022.
//

@testable import SCG_phlong
import RxSwift

class ListNewsNavigatorMock: ListNewsNavigatorDefault {
    var didCallGoToNewsDetail = false
    var itemSelected: Article = Article()
    
    func goToNewsDetail(_ item: Article) {
        didCallGoToNewsDetail = true
        itemSelected = item
    }
}

class ListNewsUseCaseMock: ListNewsUseCaseDefault {
    var didCallGetListNews = false
    var isSearch = false
    var isPullRefresh = false
    
    func getListNews(page: Int, searchString: String?) -> Observable<ListNewsModel> {
        didCallGetListNews = true
        return Observable.just(createMockListNewsModel())
        
    }
    
    func createMockListNewsModel() -> ListNewsModel {
        var model = ListNewsModel()
        var article: Article = Article()
        if isSearch {
            article = Article(author: "searchAuthor1", title: "1", description: "des1", url: "https://google.com.vn", urlToImage: "https://www.google.com.vn/", publishedAt: "10/05/1997", content: "content1")
        } else if isPullRefresh {
            article = Article(author: "pullRFAuthor1", title: "1", description: "des1", url: "https://google.com.vn", urlToImage: "https://www.google.com.vn/", publishedAt: "10/05/1997", content: "content1")
        } else {
            article = Article(author: "author1", title: "title1", description: "des1", url: "https://google.com.vn", urlToImage: "https://www.google.com.vn/", publishedAt: "10/05/1997", content: "content1")
        }
        
        let articles = [article]
        model.articles = articles
        
        return model
    }
}
