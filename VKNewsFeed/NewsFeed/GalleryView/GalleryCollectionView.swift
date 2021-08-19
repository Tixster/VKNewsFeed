//
//  GalleryCollectionView.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 19.08.2021.
//

import Foundation
import UIKit

class GalleryCollectionView: UICollectionView {
    
    private var photos = [FeedCellPhotoAttachmentViewModel]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.cellId)
        delegate = self
        dataSource = self
        backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        reloadData()
    }
    
}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageUrl: photos[indexPath.item].photoUrlString)
        return cell
    }
    
    
}
