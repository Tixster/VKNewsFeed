//
//  NewsFeedCellLayoutCalculator.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 17.08.2021.
//

import Foundation
import UIKit

protocol FeedCellLayoutCalculatorProtocol {
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes
}

struct Sizes: FeedCellSizes {
    var postLableFrame: CGRect
    var attahcmentFrame: CGRect
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
    var moreTextButtonFrame: CGRect
}

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    static let topViewHeight: CGFloat = 45
    static let postLableInsets = UIEdgeInsets(top: Constants.topViewHeight + 15, left: 15, bottom: 15, right: 15)
    static let postLableFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHight: CGFloat = 30
    static let minifiedPostLimitLines: CGFloat = 8
    static let minifiedPostLines: CGFloat = 6
    
    static let moreTextButtonSize = CGSize(width: 170, height: 30)
    static let moreTextButtonInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
}

final class NewsFeedCellLayoutCalculator: FeedCellLayoutCalculatorProtocol {
    
    private let screenWidth: CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachments: [FeedCellPhotoAttachmentViewModel], isFullSizedPost: Bool) -> FeedCellSizes {
        
        var showMoreTextButton = false
        
        let cardViewWidth = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        
        // MARK: - Работа с postLableFrame
        
        var postLableFrame = CGRect(origin: CGPoint(x: Constants.postLableInsets.left,
                                                    y: Constants.postLableInsets.top),
                                    size: .zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLableInsets.left - Constants.postLableInsets.right
            var height = text.height(width: width, font: Constants.postLableFont)
            
            let limitHeight = Constants.postLableFont.lineHeight * Constants.minifiedPostLimitLines
            
            if !isFullSizedPost && height > limitHeight {
                height = Constants.postLableFont.lineHeight * Constants.minifiedPostLines
                showMoreTextButton = true
            }
            
            postLableFrame.size = CGSize(width: width, height: height)
        }
        
        // MARK: - Работа с moreTextButtonFrame
        var moreTextButtonSize = CGSize.zero
        
        if showMoreTextButton {
            moreTextButtonSize = Constants.moreTextButtonSize
        }
        
        let moreTextButtonOrigin = CGPoint(x: Constants.moreTextButtonInsets.left, y: postLableFrame.maxY)
        let moreTextButtonFrame = CGRect(origin: moreTextButtonOrigin, size: moreTextButtonSize)
        
        // MARK: - Работа с attahcmentFrame
        let attachmentTop = postLableFrame.size == CGSize.zero ? Constants.postLableInsets.top : moreTextButtonFrame.maxY + Constants.postLableInsets.bottom
        
        var attahcmentFrame = CGRect(origin: CGPoint(x: 0,
                                                     y: attachmentTop),
                                    size: .zero)
        
//        if let attachment = photoAttachments {
//            let photoHeight: Float = Float(attachment.height)
//            let photoWidth: Float = Float(attachment.width)
//            let ratio = CGFloat(photoHeight / photoWidth)
//            attahcmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
//        }
        
        if let attachment = photoAttachments.first {
            let photoHeight: Float = Float(attachment.height)
            let photoWidth: Float = Float(attachment.width)
            let ratio = CGFloat(photoHeight / photoWidth)
            if photoAttachments.count == 1 {
                attahcmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            } else if photoAttachments.count > 1 {
                var photos = [CGSize]()
                for photo in photoAttachments {
                    let photoSize = CGSize(width: CGFloat(photo.width), height: CGFloat(photo.height))
                    photos.append(photoSize)
                }
                let rowHeight = RowLayout.rowHeightContent(superviewWidth: cardViewWidth, photosArray: photos)
                attahcmentFrame.size = CGSize(width: cardViewWidth, height: rowHeight!)
            }
        }
        
        // MARK: - Работа с bottomViewFrame
        let bottomViewTop = max(postLableFrame.maxY, attahcmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHight))
        
        // MARK: - Работа с totalHeight
        
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom

        
        return Sizes(postLableFrame: postLableFrame,
                     attahcmentFrame: attahcmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight,
                     moreTextButtonFrame: moreTextButtonFrame)
    }
    
}


