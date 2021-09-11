//
//  CaptionCollectionViewCell.swift
//  RAK
//
//  Created by James Phillips on 7/18/21.
//

import UIKit

protocol PostCaptionCollectionViewCellDelegate: AnyObject {
    func PostCaptionCollectionViewCellDidTapCaption(_ cell: PostCaptionCollectionViewCell )
}

final class PostCaptionCollectionViewCell: UICollectionViewCell {
    static let identifier = "CaptionCollectionViewCell"
    
    weak var delegate: PostCaptionCollectionViewCellDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.isUserInteractionEnabled = true
       
        return label
    }()
    
    @objc
    func didTapCaption(){
        delegate?.PostCaptionCollectionViewCellDidTapCaption(self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(label)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapCaption))
        label.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = label.sizeThatFits(CGSize(width: contentView.bounds.size.width - 12, height: contentView.bounds.size.height))
        label.frame = CGRect(x: 12, y: 3, width: size.width - 12, height: size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    func configure(with viewModel: PostCaptionCollectionViewCellViewModel)  {
        label.text = "\(viewModel.username): \(viewModel.caption ?? "" )"
    }
}
