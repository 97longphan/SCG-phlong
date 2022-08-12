//
//  ListNewsViewController.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import UIKit
import RxSwift
import RxCocoa


class ListNewsViewController: BaseViewController {
    @IBOutlet weak var listNewsTbv: UITableView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    private var viewModel: ListNewsViewModel
    private var cellIdentify = "NewsTableViewCell"
    
    init(viewModel: ListNewsViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        navigationController?.isNavigationBarHidden = true
        listNewsTbv.register(UINib(nibName: cellIdentify, bundle: nil), forCellReuseIdentifier: cellIdentify)
    }
    
    override func bindViewModel() {
        let input = ListNewsViewModel.Input(didLoadTrigger: rx.sentMessage(#selector(UIViewController.viewWillAppear))
            .mapToVoid().take(1))
        
        let output = viewModel.transform(input: input)
        
        output.hideLoading
            .drive(activity.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.articles.bind(to: listNewsTbv.rx.items(cellIdentifier: cellIdentify, cellType: NewsTableViewCell.self)) { _, item, cell in
            cell.configCell(item)
        }.disposed(by: disposeBag)
    }
}
