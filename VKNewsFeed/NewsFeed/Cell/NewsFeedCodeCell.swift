//
//  NewsFeedCodeCell.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 18.08.2021.
//

import Foundation
import UIKit
import SnapKit

protocol NewsFeedCodeCellDelegate: AnyObject {
    func revealPost(for cell: NewsFeedCodeCell)
}

final class NewsFeedCodeCell: UITableViewCell {
    
    static let cellId = "NewsFeedCodeCell"
    
    weak var delegate: NewsFeedCodeCellDelegate?
    
    private let galleryCollectionView = GalleryCollectionView()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private let topView = UIView()
    
//    private let postLabel: UILabel = {
//        let lable = UILabel()
//        lable.numberOfLines = 0
//        lable.font = Constants.postLableFont
//        return lable
//    }()
    
    private let postLabel: UITextView = {
        let textView = UITextView()
        textView.font = Constants.postLableFont
        textView.isScrollEnabled = false
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.dataDetectorTypes = UIDataDetectorTypes.all
        let padding = textView.textContainer.lineFragmentPadding
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -padding, bottom: 0, right: -padding)
        return textView
    }()
    
    private let postImageView: WebImageView = {
        let image = WebImageView()
        image.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
        return image
    }()
    
    private let bottomView = UIView()
    
    private let iconImageView: WebImageView = {
        let icon = WebImageView()
        icon.layer.cornerRadius = Constants.topViewHeight / 2
        icon.clipsToBounds = true
        return icon
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = .systemGray
        return label
    }()
    
    private let likesView = UIView()
    
    private let likesImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "like")
        return image
    }()
    
    private let likesLable: UILabel = {
        let lable = UILabel()
        lable.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        lable.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lable.lineBreakMode = .byClipping
        return lable
    }()
    
    private let sharesView = UIView()
    
    private let sharesImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "share")
        return image
    }()
    
    private let sharesLable: UILabel = {
        let lable = UILabel()
        lable.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        lable.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lable.lineBreakMode = .byClipping
        return lable
    }()
    
    private let commentsView = UIView()
    
    private let commentsImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "comment")
        return image
    }()
    
    private let commentsLable: UILabel = {
        let lable = UILabel()
        lable.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        lable.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lable.lineBreakMode = .byClipping
        return lable
    }()
    
    private let viewsView = UIView()
    
    private let viewsImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "eye")
        return image
    }()
    
    private let viewsLable: UILabel = {
        let lable = UILabel()
        lable.textColor = #colorLiteral(red: 0.5058823529, green: 0.5490196078, blue: 0.6, alpha: 1)
        lable.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lable.lineBreakMode = .byClipping
        return lable
    }()
    
    private lazy var moreTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.setTitleColor(#colorLiteral(red: 0.4, green: 0.6235294118, blue: 0.831372549, alpha: 1), for: .normal)
        button.contentHorizontalAlignment = .left
        button.contentVerticalAlignment = .center
        button.setTitle("Показать полность...", for: .normal)
        button.addTarget(self, action: #selector(tappedMoreTextButton), for: .touchUpInside)
        return button
    }()
    
    override func prepareForReuse() {
        iconImageView.set(imageURL: nil)
        postImageView.set(imageURL: nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupMainViews()
        backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    
    func fill(viewModel: FeedCellViewModel) {
        
        iconImageView.set(imageURL: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLable.text = viewModel.likes
        commentsLable.text = viewModel.comments
        sharesLable.text = viewModel.shares
        viewsLable.text = viewModel.view
        
        postLabel.frame = viewModel.sizes.postLableFrame
        bottomView.frame = viewModel.sizes.bottomViewFrame
        moreTextButton.frame = viewModel.sizes.moreTextButtonFrame

        if let photoAttachment = viewModel.photoAttachements.first, viewModel.photoAttachements.count == 1 {
            postImageView.set(imageURL: photoAttachment.photoUrlString)
            postImageView.isHidden = false
            galleryCollectionView.isHidden = true
            postImageView.frame = viewModel.sizes.attahcmentFrame
        } else if viewModel.photoAttachements.count > 1 {
            galleryCollectionView.frame = viewModel.sizes.attahcmentFrame
            postImageView.isHidden = true
            galleryCollectionView.isHidden = false
            galleryCollectionView.set(photos: viewModel.photoAttachements)
        } else {
            postImageView.isHidden = true
            galleryCollectionView.isHidden = true
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func tappedMoreTextButton() {
        delegate?.revealPost(for: self)
    }
    
    private func setupMainViews() {
        contentView.addSubview(cardView)
        cardView.addSubview(topView)
        cardView.addSubview(postLabel)
        cardView.addSubview(moreTextButton)
        cardView.addSubview(postImageView)
        cardView.addSubview(bottomView)
        cardView.addSubview(galleryCollectionView)
        
        cardView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.trailing.bottom.equalToSuperview().offset(-10)
        })
        
        topView.snp.makeConstraints({
            $0.leading.equalTo(cardView.snp.leading).inset(15)
            $0.trailing.equalTo(cardView.snp.trailing).offset(-15)
            $0.top.equalTo(cardView.snp.top).inset(10)
            $0.height.equalTo(Constants.topViewHeight)
        })
        
        setupTopView()
        setupBottomView()
        
    }
    
    private func setupTopView() {
        topView.addSubview(iconImageView)
        topView.addSubview(nameLabel)
        topView.addSubview(dateLabel)
        
        iconImageView.snp.makeConstraints({
            $0.leading.top.equalToSuperview()
            $0.height.equalToSuperview()
            $0.width.equalTo(Constants.topViewHeight)
        })
        
        nameLabel.snp.makeConstraints({
            $0.leading.equalTo(iconImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.top.equalToSuperview().inset(2)
            $0.height.equalTo(Constants.topViewHeight / 2 - 2)
        })
        
        dateLabel.snp.makeConstraints({
            $0.leading.equalTo(iconImageView.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().offset(-5)
            $0.top.equalTo(nameLabel.snp.bottom).inset(2)
            $0.height.equalTo(14)
        })
    }
    
    private func setupBottomView() {
        bottomView.addSubview(likesView)
        bottomView.addSubview(commentsView)
        bottomView.addSubview(sharesView)
        bottomView.addSubview(viewsView)
        
        likesView.snp.makeConstraints({
            $0.leading.top.height.equalToSuperview()
        })
        
        commentsView.snp.makeConstraints({
            $0.top.height.equalToSuperview()
            $0.leading.equalTo(likesView.snp.trailing)
        })
        
        sharesView.snp.makeConstraints({
            $0.top.height.equalToSuperview()
            $0.leading.equalTo(commentsView.snp.trailing)
        })
        
        viewsView.snp.makeConstraints({
            $0.top.trailing.height.equalToSuperview()
        })
        
        setupButtomViewElements()
        
    }
    
    private func setupButtomViewElements() {
 
        helpInBottomViewElements(view: likesView, imageView: likesImage, lable: likesLable)
        helpInBottomViewElements(view: commentsView, imageView: commentsImage, lable: commentsLable)
        helpInBottomViewElements(view: sharesView, imageView: sharesImage, lable: sharesLable)
        helpInBottomViewElements(view: viewsView, imageView: viewsImage, lable: viewsLable)

    }
    
    private func helpInBottomViewElements(view: UIView, imageView: UIImageView, lable: UILabel) {
        view.addSubview(imageView)
        view.addSubview(lable)

        imageView.snp.makeConstraints({
            $0.leading.top.equalToSuperview().offset(5)
            $0.bottom.equalToSuperview().offset(-5)
            $0.height.width.equalTo(20)
        })
        
        lable.snp.makeConstraints({
            $0.trailing.bottom.equalToSuperview().offset(-5)
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(imageView.snp.trailing).offset(5)
        })
    }
    
    
    
}
