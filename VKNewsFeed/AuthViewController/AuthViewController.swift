//
//  ViewController.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 14.08.2021.
//

import UIKit
import SnapKit

class AuthViewController: UIViewController {
    
    private var authService = AuthService.shared
    
    private var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Войти в VK", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(tappedLogingButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupButton()
    }
    
    private func setupButton() {
        view.addSubview(loginButton)
        
        loginButton.snp.makeConstraints({
            $0.center.equalTo(view)
        })
    
    }
    
    @objc
    private func tappedLogingButton() {
        authService.wakeUpSession()
    }


}

