//
//  NewsFeedViewController.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 16.08.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit

protocol NewsFeedDisplayLogic: AnyObject {
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData)
}

class NewsFeedViewController: UIViewController, NewsFeedDisplayLogic {
    
    var interactor: NewsFeedBusinessLogic?
    var router: (NSObjectProtocol & NewsFeedRoutingLogic)?
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = .none
        table.register(UINib(nibName: NewsFeedCell.cellId, bundle: nil), forCellReuseIdentifier: NewsFeedCell.cellId)
        table.register(NewsFeedCodeCell.self, forCellReuseIdentifier: NewsFeedCodeCell.cellId)
        return table
    }()
    
    private var feedViewModel = FeedViewModel(cells: [], footerTitle: nil)
    private var titleView = TitleView()
    private var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return control
    }()
    private lazy var footerView = FooterView()
    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = NewsFeedInteractor()
        let presenter             = NewsFeedPresenter()
        let router                = NewsFeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupTableView()
        interactor?.makeRequest(request: .getNewsFeed)
        interactor?.makeRequest(request: .getUser)
        setupTopBars()
        
    }
    
    private func setupTopBars() {
        navigationController?.hidesBarsOnSwipe = true
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.titleView = titleView
    }
    
    @objc
    private func refresh() {
        interactor?.makeRequest(request: .getNewsFeed)
    }
    
    func displayData(viewModel: NewsFeed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayNewsFeed(let feedViewModel):
            self.feedViewModel = feedViewModel
            tableView.reloadData()
            refreshControl.endRefreshing()
            footerView.setTitle(title: feedViewModel.footerTitle)
        case .displayUser(let userViewModel):
            titleView.set(userViewModel: userViewModel)
        case .displayFooterLoaerd:
            footerView.showLoader()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y > scrollView.contentSize.height / 1.1 {
            interactor?.makeRequest(request: .getNextBatch)
        }
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.addSubview(refreshControl)
        tableView.backgroundColor = .clear
        view.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        let topInset: CGFloat = 8
        tableView.contentInset.top = topInset
        tableView.tableFooterView = footerView
        
        tableView.snp.makeConstraints( {
            $0.edges.equalToSuperview()
        })
    }
    
}

extension NewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedViewModel.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCell.cellId, for: indexPath) as! NewsFeedCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedCodeCell.cellId, for: indexPath) as! NewsFeedCodeCell
        let cellViewModel = feedViewModel.cells[indexPath.row]
        cell.fill(viewModel: cellViewModel)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellViewModel = feedViewModel.cells[indexPath.row]
        return cellViewModel.sizes.totalHeight
    }
    
}


extension NewsFeedViewController: NewsFeedCodeCellDelegate {
    func revealPost(for cell: NewsFeedCodeCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let cellViewModel = feedViewModel.cells[indexPath.row]
        interactor?.makeRequest(request: .revealPostIds(postId: cellViewModel.postId))
    }
    
    
}
