//
//  DetailViewController.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    // MARK: MAIN PROPERTIES
    
    /// Table row type: property name ans its value
    typealias tableRow = (property: String, value: String)

    /// Placemark, the details of which will be show
    var placemark: Placemark? { didSet { updateUI() } }

    /// Data source of TableView
    private var dataSource = [tableRow]() { didSet { tableView.reloadData() } }
    
    // MARK: UI VIEWS
    
    @IBOutlet weak var tableView: UITableView! { didSet { tableView.tableFooterView = UIView() } }
    
    // MARK: VIEW CONTROLLER'S LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: MAIN LOGIC
    
    private func updateUI() {
        
        guard self.isViewLoaded else { return }
        
        title = placemark?.name
        
        guard let placemark = placemark else {
            dataSource = []
            return
        }
        
        var tableData = [
            ("Name", placemark.name),
            ("VIN", placemark.vin),
            ("Address", placemark.address),
            ("Interior", placemark.interior),
            ("Exterior", placemark.exterior),
            ("Engine Type", placemark.engineType),
            ("Fuel", String(placemark.fuel)),
        ]
        
        if let coordinate = placemark.coordinate2D {
            tableData += [
                ("Latitude", String(coordinate.latitude)),
                ("Longitude", String(coordinate.longitude)),
            ]
        }
        
        dataSource = tableData
    }
    
}

extension DetailViewController: UITableViewDataSource {
    
    private var reuseCellID: String { return "cell" }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataSource[indexPath.row]
        let cell = UITableViewCell(style: .value2, reuseIdentifier: reuseCellID)
        cell.textLabel?.text = item.property
        cell.detailTextLabel?.text = item.value
        cell.detailTextLabel?.numberOfLines = 0
        return cell
    }
    
}
