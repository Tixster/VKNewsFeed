//
//  FooterView.swift
//  VKNewsFeed
//
//  Created by Кирилл Тила on 20.08.2021.
//

import Foundation
import UIKit
import SnapKit

class FooterView: UIView {
    
    private var myLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 13)
        lable.textColor = #colorLiteral(red: 0.631372549, green: 0.6470588235, blue: 0.662745098, alpha: 1)
        lable.textAlignment = .center
        return lable
    }()
    
    private var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView()
        loader.hidesWhenStopped = true
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(myLable)
        addSubview(loader)
        
        myLable.snp.makeConstraints({
            $0.top.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(20)
            $0.trailing.equalToSuperview().offset(-20)
        })
        
        loader.snp.makeConstraints({
            $0.top.equalTo(myLable.snp.bottom).inset(8)
            $0.center.equalToSuperview()
        })
    }
    
    func showLoader() {
        loader.startAnimating()
    }
    
    func setTitle(title: String?) {
        loader.stopAnimating()
        myLable.text = title
    }
    
}

