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
    
    func makeRequest(request: NewsFeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsFeedService()
        }
        
        switch request {
        
        case .getNewsFeed:
            service?.getFeed(response: { [weak self] revealedPostIds, feed in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostIds: revealedPostIds))
            })
        case .revealPostIds(let postId):
            service?.revealPostIds(forPostId: postId, completion: { [weak self] revealedPostIds, feed in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostIds: revealedPostIds))
            })
        case .getUser:
            service?.getUser(response: { [weak self] user in
                self?.presenter?.presentData(response: .presentUserInfo(user: user))
            })
        case .getNextBatch:
            presenter?.presentData(response: .presentFooterLoader)
            service?.getNextBatch(response: { [weak self] revealedPostIds, feed in
                self?.presenter?.presentData(response: .presentNewsFeed(feed: feed, revealedPostIds: revealedPostIds))
            })
        }
 
    }
 
}
