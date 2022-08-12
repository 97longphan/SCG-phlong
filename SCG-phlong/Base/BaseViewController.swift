//
//  BaseViewController.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import Foundation
import UIKit
import RxSwift
class BaseViewController: UIViewController {
    private(set) var disposeBag = DisposeBag()
    
    init() {
        super.init(nibName: Self.className, bundle: Bundle(for: type(of: self)))
    }
    
    @available(iOS, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(NSStringFromClass(self.classForCoder) + "." + #function)
    }
    
    deinit {
        print(NSStringFromClass(self.classForCoder) + "." + #function)
        NotificationCenter.default.removeObserver(self)
    }
    
    func bindViewModel() {}
    func setupViews() {}
    
}

public extension NSObject {
    class var className: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
