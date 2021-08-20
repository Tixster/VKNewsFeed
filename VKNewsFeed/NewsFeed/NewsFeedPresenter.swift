//
//  NewsFeedPresenter.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 16.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedPresentationLogic {
    func presentData(response: NewsFeed.Model.Response.ResponseType)
}

class NewsFeedPresenter: NewsFeedPresentationLogic {
    
    var cellLayoutCalculator: FeedCellLayoutCalculatorProtocol = NewsFeedCellLayoutCalculator()
    
    weak var viewController: NewsFeedDisplayLogic?
    private let dateFormatter: DateFormatter = {
        let formmater = DateFormatter()
        formmater.locale = Locale(identifier: "ru_RU")
        formmater.dateFormat = "d MMM 'в' HH:mm"
        return formmater
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
        
        case .presentNewsFeed(let feed, let revealedPostIds):

            let cells = feed.items.map { feedItem in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups, revealedPostIds: revealedPostIds)
            }
            let feedViewModel = FeedViewModel(cells: cells)
            
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        case .presentUserInfo(let user):
            let userViewModel = UserViewModel(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: .displayUser(userViewModel: userViewModel))
        }
        
    }
    
    private func cellViewModel(from feedItem: FeedItems, profiles: [Profile], groups: [Group], revealedPostIds: [Int]) -> FeedViewModel.Cell {
        
        let profile = profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let isFullSised = revealedPostIds.contains(feedItem.postId)
        let photoAttachments = photoAttachments(feedItem: feedItem)

        let sizes = cellLayoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizedPost: isFullSised)
        
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "/n")
        
        return FeedViewModel.Cell(iconUrlString: profile.photo,
                                  name: profile.name,
                                  date: dateTitle,
                                  text: postText,
                                  likes: formatterCounter(feedItem.likes?.count),
                                  comments: formatterCounter(feedItem.comments?.count),
                                  shares: formatterCounter(feedItem.reposts?.count),
                                  view: formatterCounter(feedItem.views?.count),
                                  photoAttachements: photoAttachments,
                                  sizes: sizes,
                                  postId: feedItem.postId)
    }
    
    private func formatterCounter(_ counter: Int?) -> String? {
        guard let counter = counter, counter > 0 else { return nil }
        var counterString = "\(counter)"
        if 4...6 ~= counterString.count {
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        return counterString
    }
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileReperesentable {
        let profilesOrGroups: [ProfileReperesentable] = sourseId >= 0 ? profiles : groups
        let normalSourseId = sourseId >= 0 ? sourseId : -sourseId
        let profileRepresentable = profilesOrGroups.first { myProfileRepresentable -> Bool in
            myProfileRepresentable.id == normalSourseId
        }
        
        return profileRepresentable!
    }
    
    private func photoAttachment(feedItem: FeedItems) -> FeedViewModel.FeedCellPhotoAttachment? {
        guard let photo = feedItem.attachments?.compactMap({ attachment in
            attachment.photo
        }), let firstPhoto = photo.first else { return nil }
        return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: firstPhoto.srcBIG,
                                                     width: firstPhoto.width,
                                                     height: firstPhoto.height)
    }
    
    private func photoAttachments(feedItem: FeedItems) -> [FeedViewModel.FeedCellPhotoAttachment] {
        guard let attachmets = feedItem.attachments else { return [] }
        return attachmets.compactMap ({ attachmet in
            guard let photo = attachmet.photo else { return nil }
            return FeedViewModel.FeedCellPhotoAttachment(photoUrlString: photo.srcBIG,
                                                         width: photo.width,
                                                         height: photo.height)
        })
    }
    
}
