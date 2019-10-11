//
//  Cell.swift
//  Mazes
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import UIKit

class Cell : NSObject {
    var row: Int
    var column: Int
    var linkedCells: NSMutableSet
    var northCell, southCell, eastCell, westCell : Cell?
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.linkedCells = NSMutableSet()
    }
    
    func link(toCell: Cell, bidirectional: Bool! = true) {
        linkedCells.add(toCell)
        if bidirectional {
            toCell.link(toCell: self, bidirectional: false)
        }
    }
    
    func unlink(fromCell: Cell, bidirectional: Bool! = true) {
        linkedCells.remove(fromCell);
        if bidirectional {
            fromCell.unlink(fromCell: self, bidirectional: false)
        }
    }
    
    func isLinkedTo(cell: Cell?) -> Bool {
        guard let cell = cell else {
            return false
        }
        return linkedCells.contains(cell)
    }

    var neighborCells: NSSet {
        get {
            let cells = NSMutableSet()
            if let northCell = northCell {
                cells.add(northCell)
            }
            if let southCell = self.southCell {
                cells.add(southCell)
            }
            if let eastCell = self.eastCell {
                cells.add(eastCell)
            }
            if let westCell = self.westCell {
                cells.add(westCell)
            }
            
            return cells.copy() as! NSSet
        }
    }
    
    override var description : String {
        return "row: \(row), column: \(column)"
    }
}

extension Cell {
    func topWallAsAscii() -> String {
        guard let northCell = northCell, isLinkedTo(cell: northCell) else {
            return "+---"
        }

        return "+   "
    }

    func bodyAsAscii() -> String {
        guard let westCell = westCell, isLinkedTo(cell: westCell) else {
            return "|   "
        }

        return "    "
    }

    func bottomWallAsAscii() -> String {
        guard let southCell = southCell, isLinkedTo(cell: southCell) else {
            return "+---"
        }

        return "+   "
    }
}
