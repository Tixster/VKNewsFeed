//
//  TitleView.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 20.08.2021.
//

import Foundation
import UIKit
import SnapKit

protocol TitleViewViewModel {
    var photoUrlString: String? { get }
}

class TitleView: UIView {
    
    private let myAvatarView: WebImageView = {
        let image = WebImageView()
        image.backgroundColor = .orange
        image.clipsToBounds = true
        return image
    }()
    
    private let myTextField = InsetableTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    func set(userViewModel: TitleViewViewModel) {
        myAvatarView.set(imageURL: userViewModel.photoUrlString)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myAvatarView.layer.masksToBounds = true
        myAvatarView.layer.cornerRadius = myAvatarView.frame.width / 2 
    }
    
    private func setupViews() {
        addSubview(myAvatarView)
        addSubview(myTextField)
        
        myAvatarView.snp.makeConstraints({
            $0.trailing.equalToSuperview().offset(-4)
            $0.top.equalToSuperview().offset(4)
            $0.height.width.equalTo(myTextField.snp.height)
        })
        
        myTextField.snp.makeConstraints({
            $0.leading.top.equalToSuperview().inset(4)
            $0.bottom.equalToSuperview().offset(-4)
            $0.trailing.equalTo(myAvatarView.snp.leading).offset(-12)
        })
        
    }
    
}
