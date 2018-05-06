//
//  MainViewController.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    // MARK: MAIN PROPERTIES

    // External dependencies
    private var networkManager: NetworkManagerProtocol = NetworkManager()

    /// Data Source, on getting data, passes it to all childs, who support the appropriate protocol
    private var dataSource: [Placemark]? {
        didSet {
            allChildViewControllers.compactMap { $0 as? PlacemarksDataSourceShowing }.forEach { $0.dataSource = dataSource }
        }
    }

    // MARK: UI VIEWS

    // Helper views for loading data and show loading errors
    private lazy var loadingView = LoadingView()
    private lazy var errorLoadingView: ErrorLoadingView = {
        let view = ErrorLoadingView()
        view.reloadHandler = { [weak self] in self?.loadData() }
        return view
    }()

    // MARK: VIEW CONTROLLER'S LIFE CYCLE

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }

    // MARK: MAIN LOGIC

    private func loadData() {

        DispatchQueue.main.async {
            self.view.addSubview(self.loadingView)
            self.errorLoadingView.removeFromSuperview()
        }

        DispatchQueue.global(qos: .userInitiated).async {
            defer {
                DispatchQueue.main.async {
                    UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: {
                        self.loadingView.removeFromSuperview()
                    }, completion: nil)
                }
            }
            self.networkManager.loadData(
                successHandler: { self.dataSource = $0 },
                errorHandler: { (error) in
                    DispatchQueue.main.async {
                        self.errorLoadingView.setDefaultText(for: error)
                        self.view.addSubview(self.errorLoadingView)
                    }
            }
            )
        }
    }

}
