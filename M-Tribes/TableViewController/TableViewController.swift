//
//  TableViewController.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, PlacemarksDataSourceShowing {

    // MARK: MAIN PROPERTIES

    /// Data Source of Table View
    var dataSource: [Placemark]? { didSet { updateUI() } }

    // MARK: UI VIEWS

    @IBOutlet weak var tableView: UITableView!

    // MARK: VIEW CONTROLLER'S LIFE CYCLE

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    // MARK: MAIN LOGIC

    private func updateUI() {

        guard self.isViewLoaded else { return }

        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }

    // MARK: NAVIGATION

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        guard
            segue.identifier == "tableToDetail",
            let vc = segue.destination as? DetailViewController,
            let item = sender as? Placemark
        else { return }

        vc.placemark = item
    }

}

extension TableViewController: UITableViewDataSource {

    // MARK: TABLE VIEW DATA SOURCE

    var reusableID: String { return "cellPlacemark" }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableID, for: indexPath)
        if let cell = cell as? PlacemarkViewCell, let item = dataSource?[indexPath.row] {
            cell.configCell(item)
        }
        return cell
    }

}

extension TableViewController: UITableViewDelegate {

    // MARK: TABLE VIEW DELEGATE
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = dataSource?[indexPath.row] {
            performSegue(withIdentifier: "tableToDetail", sender: item)
        }
    }

}
