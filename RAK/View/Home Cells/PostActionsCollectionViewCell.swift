//
//  PostActionsCollectionViewCell.swift
//  RAK
//
//  Created by James Phillips on 7/18/21.
//

import UIKit

protocol PostActionsCollectionViewCellDelegate: AnyObject {
    func PostActionsCollectionViewCellDidTapLike(_ cell: PostActionsCollectionViewCell, isLiked: Bool, index: Int)
    func PostActionsCollectionViewCellDidTapComment(_ cell: PostActionsCollectionViewCell, index: Int)
    func PostActionsCollectionViewCellDidTapShare(_ cell: PostActionsCollectionViewCell, index: Int)
}

final class PostActionsCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostActionsCollectionViewCell"
    
    private var index = 0
    
    weak var delegate: PostActionsCollectionViewCellDelegate?
    
    private var isLiked = false
    
    private let likeButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "suit.heart",withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let commentButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "message",withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    private let shareButton : UIButton = {
        let button = UIButton()
        button.tintColor = .label
        let image = UIImage(systemName: "paperplane",withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
        button.setImage(image, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.addSubview(likeButton)
        contentView.addSubview(commentButton)
        contentView.addSubview(shareButton)
        
        likeButton.addTarget(self, action: #selector(didTapLike), for: .touchUpInside)
        commentButton.addTarget(self, action: #selector(didTapComment), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc
    func didTapLike()  {
        if self.isLiked{
            let image = UIImage(systemName: "suit.heart",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .label
        }else{
            let image = UIImage(systemName: "suit.heart.fill",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
        delegate?.PostActionsCollectionViewCellDidTapLike(self, isLiked: !isLiked, index: index)
        self.isLiked = !isLiked
    }
    
    @objc
    func didTapComment()  {
        delegate?.PostActionsCollectionViewCellDidTapComment(self, index: index)
    }
    
    @objc
    func didTapShare()  {
        delegate?.PostActionsCollectionViewCellDidTapShare(self, index: index)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.height / 1.15
        likeButton.frame = CGRect(x: 10, y: (contentView.height - size), width: size, height: size)
        commentButton.frame = CGRect(x: likeButton.right + 12, y: (contentView.height - size), width: size, height: size)
        shareButton.frame = CGRect(x: commentButton.right + 12, y: (contentView.height - size), width: size, height: size)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(
        with viewModel: PostActionsCollectionViewCellViewModel,
        index: Int)  {
        self.index = index
        isLiked = viewModel.isLiked
        if viewModel.isLiked{
            let image = UIImage(systemName: "suit.heart.fill",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 44))
            likeButton.setImage(image, for: .normal)
            likeButton.tintColor = .systemRed
        }
    }
}
