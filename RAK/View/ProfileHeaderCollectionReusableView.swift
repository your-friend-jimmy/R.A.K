//
//  ProfileHeaderCollectionReusableView.swift
//  RAK
//
//  Created by James Phillips on 8/23/21.
//

import UIKit

protocol ProfileHeaderCollectionReusableViewDelegate: AnyObject {
    func ProfileHeaderCollectionReusableViewDidTapProfilePicture(_ header: ProfileHeaderCollectionReusableView)
}

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ProfileHeaderCollectionReusableView"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    weak var delegate: ProfileHeaderCollectionReusableViewDelegate?
    
    public let countContainerView = ProfileHeaderCountView()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Academy\nThis is my profile bio!"
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(countContainerView)
        addSubview(imageView)
        addSubview(bioLabel)
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage
                )
        )
        
        imageView.addGestureRecognizer(tap)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc
    func didTapImage() {
        delegate?.ProfileHeaderCollectionReusableViewDidTapProfilePicture(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = width/3.5
        imageView.frame = CGRect(x: 5, y: 5, width: imageSize, height: imageSize)
        imageView.layer.cornerRadius = imageSize/2
        countContainerView.frame = CGRect(
            x: imageView.right+5,
            y: 3, width: width-imageView.right - 10,
            height: imageSize
        )
        bioLabel.sizeToFit()
        let size = bioLabel.sizeThatFits(bounds.size)
        bioLabel.frame = CGRect(
            x: 5,
            y: imageView.bottom+10,
            width: size.width-10,
            height: size.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        bioLabel.text = nil
    }
    
    public func configure(with viewModel: ProfileHeaderViewModel){
        imageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        var text = ""
        if let name = viewModel.name {
            text = name + "\n"
        }
        text += viewModel.bio ?? "Welcome to my profile"
        bioLabel.text = text
        //Container
        let containerViewModel = ProfileHeaderCountViewViewModel(
            followerCount: viewModel.followerCount,
            followingCount: viewModel.followingCount,
            postCount: viewModel.postCount,
            actionType: viewModel.buttonType
        )
        countContainerView.configure(with: containerViewModel)
    }
}
