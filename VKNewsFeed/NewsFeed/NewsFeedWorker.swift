//
//  NewsFeedWorker.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 16.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class NewsFeedService {

    private var fetcher: DataFetcher = NetworkDataFetcher(networking: NetworkService())
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    private var newFromInProcess: String?
 
    func getUser(response: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { userResponse in
            response(userResponse)
        }
    }
    
    func getFeed(response: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBacthFrom: nil) { [weak self] feedResponse in
            self?.feedResponse = feedResponse
            guard let feedResponse = self?.feedResponse else { return }
            response(self!.revealedPostIds, feedResponse)
        }
    }

    func revealPostIds(forPostId postId: Int, completion: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        completion(revealedPostIds, feedResponse)
    }
    
    func getNextBatch(response: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBacthFrom: newFromInProcess) { [weak self] feed in
            guard let feed = feed else { return }
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                self?.feedResponse?.items.append(contentsOf: feed.items)
                self?.feedResponse?.nextFrom = feed.nextFrom
                var profiles = feed.profiles
                if let oldProfile = self?.feedResponse?.profiles {
                    let oldProfileFiltered = oldProfile.filter { oldProfile -> Bool in
                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
                    }
                    profiles.append(contentsOf: oldProfileFiltered)
                }
                self?.feedResponse?.profiles = profiles
               
                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter { oldGroups -> Bool in
                        !feed.groups.contains(where: { $0.id == oldGroups.id })
                    }
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self?.feedResponse?.groups = groups
            }
            
            guard let feedResponse = self?.feedResponse else { return }
            
            response(self!.revealedPostIds, feedResponse)
        }
    }
}
