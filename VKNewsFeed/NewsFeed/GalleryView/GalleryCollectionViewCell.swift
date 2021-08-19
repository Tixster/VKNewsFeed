//
//  GalleryCollectionViewCell.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 19.08.2021.
//

import Foundation
import UIKit
import SnapKit

class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "GalleryCollectionViewCell"
    
    private let myImageView: WebImageView = {
        let image = WebImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        setupMyImageView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        myImageView.image = nil
    }
    
    private func setupMyImageView() {
        contentView.addSubview(myImageView)
        
        myImageView.snp.makeConstraints({
            $0.edges.equalToSuperview()
        })
    }
    
    func set(imageUrl: String?) {
        myImageView.set(imageURL: imageUrl)
    }
    
}
