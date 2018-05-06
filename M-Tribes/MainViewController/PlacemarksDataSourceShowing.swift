//
//  PlacemarksDataSourceShowing.swift
//  M-Tribes
//
//  Created by Antony Karpov on 30/04/2018.
//  Copyright © 2018 Antony Karpov. All rights reserved.
//

import Foundation

protocol PlacemarksDataSourceShowing: class {

    var dataSource: [Placemark]? { get set }

}
