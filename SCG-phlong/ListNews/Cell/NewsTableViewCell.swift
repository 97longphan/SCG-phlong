//
//  NewsTableViewCell.swift
//  SCG-phlong
//
//  Created by phlong on 12/08/2022.
//

import UIKit
import Kingfisher

class NewsTableViewCell: BaseTableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var thumbImv: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func setupViews() {
        thumbImv.layer.cornerRadius = 8
    }
    
    func configCell(_ model: Article) {
        desLabel.text = model.description
        titleLabel.text = model.title
        dateLabel.text = model.publishedAt
        if let urlToImage = model.urlToImage, let url = URL(string: urlToImage) {
            thumbImv.kf.setImage(with: url)
        }
    }
    
}
