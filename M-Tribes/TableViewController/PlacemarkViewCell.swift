//
//  PlacemarkViewCell.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import UIKit

class PlacemarkViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var vinLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!

    func configCell(_ placemark: Placemark) {
        addressLabel.text = placemark.address
        vinLabel.text = placemark.vin
        nameLabel.text = placemark.name
    }

}
