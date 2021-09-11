//
//  PostLikesCollectionViewCell.swift
//  RAK
//
//  Created by James Phillips on 7/18/21.
//

import UIKit

protocol PostLikesCollectionViewCellDelegate: AnyObject {
    func postLikesCollectionViewCellDidTapLikeCount(_ cell: PostLikesCollectionViewCell)
}

class PostLikesCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostLikesCollectionViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private var index = 0
    
    weak var delegate: PostLikesCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapLabel))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapLabel(){
        delegate?.postLikesCollectionViewCellDidTapLikeCount(self)
    }
    
    override func layoutSubviews() {
        label.frame = CGRect(x: 10, y: 0, width: contentView.width - 12 , height: contentView.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }

    func configure(with viewModel: PostLikesCollectionViewCellViewModel) {
        let users = viewModel.likers
        label.text = "\(users.count) Likes"
    }
}
