//
//  Grid.swift
//  Mazes
//
//  Created by Marco Mussini on 28/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import UIKit

class Grid: NSObject {
    public var rows: Int
    public var columns: Int
    
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        super.init()
    }
}
