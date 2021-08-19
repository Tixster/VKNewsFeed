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
        let rowLyaout = RowLayout()
        super.init(frame: .zero, collectionViewLayout: rowLyaout)
        rowLyaout.delegate = self
        register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.cellId)
        delegate = self
        dataSource = self
        backgroundColor = .white
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(photos: [FeedCellPhotoAttachmentViewModel]) {
        self.photos = photos
        contentOffset = CGPoint.zero
        reloadData()
    }
    
}

extension GalleryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, RowLayoutDelegate  {
    func collectionView(_ collectionView: UICollectionView, photoAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = photos[indexPath.row].width
        let height = photos[indexPath.row].height
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.cellId, for: indexPath) as! GalleryCollectionViewCell
        cell.set(imageUrl: photos[indexPath.item].photoUrlString)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.height)
    }
    
    
}
