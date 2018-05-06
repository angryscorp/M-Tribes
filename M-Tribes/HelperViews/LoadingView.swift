//
//  LoadingView.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    // INITS

    init() {
        super.init(frame: CGRect.zero)
        configUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configUI()
    }

    private func configUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    // UI

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = .black
        addSubview(indicator)
        NSLayoutConstraint.activate([
            indicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            indicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        return indicator
    }()

    // SETTING AUTOLAYOUT

    override func didMoveToSuperview() {
        if let parentView = self.superview {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: parentView.topAnchor),
                leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ])

            OperationQueue.main.addOperation { [weak self] in
                self?.activityIndicator.startAnimating()
            }
        } else {
            self.activityIndicator.stopAnimating()
        }
    }
}
