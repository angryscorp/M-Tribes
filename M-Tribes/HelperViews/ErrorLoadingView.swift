//
//  ErrorLoadingView.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit

class ErrorLoadingView: UIView {

    // Handler for Button of repeat action
    var reloadHandler: () -> Void = {}

    // Title of main label
    var mainTitle: String? {
        get { return labelTitle.text }
        set { labelTitle.text = newValue }
    }

    private let defaultTextError = "Error of Loading Data."

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

    private lazy var labelTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 22)
        label.text = self.defaultTextError
        self.addSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: self.leftAnchor),
            label.rightAnchor.constraint(equalTo: self.rightAnchor),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        return label
    }()

    private lazy var buttonRepeat: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        button.backgroundColor = .blue
        button.setTitle("Retry", for: .normal)
        button.addTarget(self, action: #selector(actionButtonRepeat), for: .touchUpInside)
        self.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            button.topAnchor.constraint(equalTo: labelTitle.bottomAnchor, constant: 50)
        ])
        return button
    }()

    @objc private func actionButtonRepeat(sender: UIButton) {
        self.reloadHandler()
    }

    // SETTING AUTOLAYOUT

    override func didMoveToSuperview() {
        if let parentView = self.superview {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: parentView.topAnchor),
                leadingAnchor.constraint(equalTo: parentView.leadingAnchor),
                trailingAnchor.constraint(equalTo: parentView.trailingAnchor),
                bottomAnchor.constraint(equalTo: parentView.bottomAnchor)
            ])
            labelTitle.setNeedsLayout()
            buttonRepeat.setNeedsLayout()
        }
    }

    // DEFAULTS' ERROR HANDLING

    func setDefaultText(for error: Error?) {
        mainTitle = {
            guard let error = error as? URLError else { return defaultTextError }
            switch error.code {
            case URLError.notConnectedToInternet:
                return "Not connected to Internet."
            case URLError.cannotConnectToHost, URLError.cannotFindHost:
                return "Cannot connect to Server."
            default:
                return defaultTextError
            }
        }()
    }

}
