//
//  Cell.swift
//  Mazes
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import UIKit

class Cell: NSObject {
    public var row: NSInteger
    public var column: NSInteger
    public var linkedCells: NSMutableSet
    public var northCell, southCell, eastCell, westCell : Cell!
    
    public init(row: NSInteger, column: NSInteger) {
        self.row = row
        self.column = column
        self.linkedCells = NSMutableSet()
        super.init()
    }
    
    public func link(toCell: Cell, bidirectional: Bool! = true) {
        self.linkedCells.add(toCell)
        if (bidirectional) {
            toCell.link(toCell: self, bidirectional: false)
        }
    }
    
    public func unlink(fromCell: Cell, bidirectional: Bool! = true) {
        self.linkedCells.remove(fromCell);
        if (bidirectional) {
            fromCell.unlink(fromCell: self, bidirectional: false)
        }
    }
    
    public func isLinkedToCell(cell: Cell) -> Bool {
        return self.linkedCells.contains(cell)
    }
    
    public var neighborCells: NSSet {
        get {
            let cells = NSMutableSet()
            if (self.northCell != nil) {
                cells.add(self.northCell)
            }
            if (self.southCell != nil) {
                cells.add(self.southCell)
            }
            if (self.eastCell != nil) {
                cells.add(self.eastCell)
            }
            if (self.westCell != nil) {
                cells.add(self.westCell)
            }
            
            return cells.copy() as! NSSet
        }
    }
}
