//
//  BaseTableViewCell.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import RxSwift
import UIKit

class BaseTableViewCell: UITableViewCell {
    
    private(set) var disposeBag = DisposeBag()

    override func prepareForReuse() {
        disposeBag = DisposeBag()
        super.prepareForReuse()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        setupViews()
    }
    
    func setupViews() {}
}
