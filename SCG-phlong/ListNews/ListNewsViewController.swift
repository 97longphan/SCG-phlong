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
    private var viewModel: ListNewsViewModel
    private var cellIdentify = "NewsTableViewCell"
    private let loadNews = PublishSubject<Bool>()
    
    init(viewModel: ListNewsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNews.onNext(false)
    }
    
    override func setupViews() {
        navigationController?.isNavigationBarHidden = true
        listNewsTbv.register(UINib(nibName: cellIdentify, bundle: nil), forCellReuseIdentifier: cellIdentify)
        listNewsTbv.es.addInfiniteScrolling { [weak self] in
            self?.loadNews.onNext(true)
            self?.listNewsTbv.es.stopLoadingMore()
        }
    }
    
    override func bindViewModel() {
        let input = ListNewsViewModel.Input(loadNews: loadNews)
        
        let output = viewModel.transform(input: input)
        
        output.hideLoading
            .drive(activity.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.error.drive(onNext: { [weak self] in
            self?.showAlert($0.localizedDescription)
        }).disposed(by: disposeBag)
        
        output.articles.bind(to: listNewsTbv.rx.items(cellIdentifier: cellIdentify, cellType: NewsTableViewCell.self)) { _, item, cell in
            cell.configCell(item)
        }.disposed(by: disposeBag)
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Something error...",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
