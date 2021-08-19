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
        image.contentMode = .scaleAspectFill
        image.backgroundColor = #colorLiteral(red: 0.5768421292, green: 0.6187390685, blue: 0.664434731, alpha: 1)
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupMyImageView()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 10
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 2.5, height: 4)
        
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
