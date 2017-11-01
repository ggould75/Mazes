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
    public var cellsMatrix: Array<Array<Cell>>
    
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        self.cellsMatrix = []
        for row in 0...rows - 1 {
            self.cellsMatrix.append([Cell]())
            for column in 0...columns - 1 {
                let cell = Cell(row: row, column: column)
                self.cellsMatrix[row].append(cell)
            }
        }
        
        super.init()
    }
}
