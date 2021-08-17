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
    weak var viewController: NewsFeedDisplayLogic?
    private let dateFormatter: DateFormatter = {
        let formmater = DateFormatter()
        formmater.locale = Locale(identifier: "ru_RU")
        formmater.dateFormat = "d MMM 'в' HH:mm"
        return formmater
    }()
    
    func presentData(response: NewsFeed.Model.Response.ResponseType) {
        
        switch response {
        
        case .presentNewsFeed(let feed):
            let cells = feed.items.map { feedItem in
                cellViewModel(from: feedItem, profiles: feed.profiles, groups: feed.groups)
            }
            let feedViewModel = FeedViewModel(cells: cells)
            
            viewController?.displayData(viewModel: .displayNewsFeed(feedViewModel: feedViewModel))
        }
        
    }
    
    private func cellViewModel(from feedItem: FeedItems, profiles: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        
        let profile = profile(for: feedItem.sourceId, profiles: profiles, groups: groups)
        
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatter.string(from: date)
        let photoAttachment = self.photoAttachment(feedItem: feedItem)
        
        return FeedViewModel.Cell(iconUrlString: profile.photo,
                                  name: profile.name,
                                  date: dateTitle,
                                  text: feedItem.text,
                                  likes: String(feedItem.likes?.count ?? 0),
                                  comments: String(feedItem.comments?.count ?? 0),
                                  shares: String(feedItem.reposts?.count ?? 0),
                                  view: String(feedItem.views?.count ?? 0),
                                  photoAttahcment: photoAttachment)
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
    
}
