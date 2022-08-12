//
//  ListNewsViewController.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import UIKit
import RxSwift
import RxCocoa
import ESPullToRefresh

class ListNewsViewController: BaseViewController {
    @IBOutlet weak var listNewsTbv: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var viewModel: ListNewsViewModel
    private var cellIdentify = "NewsTableViewCell"
    private let loadMoreTrigger = PublishSubject<Void>()
    private let selectedCellTrigger = PublishSubject<Article>()
    private let pullRefreshTrigger = PublishSubject<Void>()
    private let searchTrigger = PublishSubject<(String)>()
    
    init(viewModel: ListNewsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    override func setupViews() {
        searchBar.delegate = self
        
        listNewsTbv.register(UINib(nibName: cellIdentify, bundle: nil), forCellReuseIdentifier: cellIdentify)
        listNewsTbv.es.addInfiniteScrolling { [weak self] in
            self?.loadMoreTrigger.onNext(())
            
        }
        
        listNewsTbv.es.addPullToRefresh { [weak self] in
            self?.pullRefreshTrigger.onNext(())
            
        }
    }
    
    override func bindViewModel() {
        let input = ListNewsViewModel.Input(didLoadTrigger: rx.sentMessage(#selector(UIViewController.viewWillAppear))
            .mapToVoid().take(1),
                                            loadMoreTrigger: loadMoreTrigger,
                                            selectedCellTrigger: selectedCellTrigger.asDriverOnErrorJustComplete(),
                                            pullRefreshTrigger: pullRefreshTrigger,
                                            searchTrigger: searchTrigger)

        let output = viewModel.transform(input: input)
        
        output.hideLoading
            .drive(activity.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.error
            .drive(onNext: { [weak self] in
                self?.showAlert($0.localizedDescription)})
            .disposed(by: disposeBag)
        
        listNewsTbv.rx
            .modelSelected(Article.self)
            .subscribe(onNext: { [weak self] in
                self?.selectedCellTrigger.onNext($0)})
            .disposed(by: disposeBag)
        
        output.articles
            .do(onNext: { [weak self] _ in
                self?.listNewsTbv.es.stopLoadingMore()
                self?.listNewsTbv.es.stopPullToRefresh() })
            .bind(to: listNewsTbv.rx.items(cellIdentifier: cellIdentify, cellType: NewsTableViewCell.self)) {_, item, cell in
                cell.configCell(item)}
            .disposed(by: disposeBag)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Something error...",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}

extension ListNewsViewController: UISearchBarDelegate {    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchTrigger.onNext((searchBar.text ?? ""))
    }
}
