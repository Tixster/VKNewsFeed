//
//  NewsFeedInteractor.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 16.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsFeedBusinessLogic {
    func makeRequest(request: NewsFeed.Model.Request.RequestType)
}

class NewsFeedInteractor: NewsFeedBusinessLogic {
    
    var presenter: NewsFeedPresentationLogic?
    var service: NewsFeedService?
    
    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        switch request {
        case .getNewsFeed:
            fetcher.getFeed { [weak self] feedResponse in
                
                self?.feedResponse = feedResponse
                self?.presentFeed()
            }
            
        case .revealPostIds(let postId):
            revealedPostIds.append(postId)
            presentFeed()
        case .getUser:
            fetcher.getUser { userResponsse in
                self.presenter?.presentData(response: .presentUserInfo(user: userResponsse))
            }
        }
    }
    private func presentFeed() {
        guard let feedResponse = feedResponse else { return }
        presenter?.presentData(response: .presentNewsFeed(feed: feedResponse, revealedPostIds: revealedPostIds))
    }
    
}
