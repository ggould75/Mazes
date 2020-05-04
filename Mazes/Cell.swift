//
//  Cell.swift
//  Mazes
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import Foundation

class Cell: NSObject {
    var row: Int
    var column: Int
    var linkedCells = Set<Cell>()
    var northCell, southCell, eastCell, westCell: Cell?
    
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
    }

    // Time: O(1) assuming insert works in constant time
    func link(toCell: Cell, bidirectional: Bool = true) {
        linkedCells.insert(toCell)
        if bidirectional {
            toCell.link(toCell: self, bidirectional: false)
        }
    }

    // Time: O(1)
    func unlink(fromCell: Cell, bidirectional: Bool = true) {
        linkedCells.remove(fromCell);
        if bidirectional {
            fromCell.unlink(fromCell: self, bidirectional: false)
        }
    }

    // Time: O(1)
    func isLinkedTo(cell: Cell?) -> Bool {
        guard let cell = cell else {
            return false
        }
        return linkedCells.contains(cell)
    }

    // Time: O(1) however a set is created each time
    var neighborCells: Set<Cell> {
        get {
            var cells = Set<Cell>()
            if let northCell = northCell {
                cells.insert(northCell)
            }
            if let southCell = self.southCell {
                cells.insert(southCell)
            }
            if let eastCell = self.eastCell {
                cells.insert(eastCell)
            }
            if let westCell = self.westCell {
                cells.insert(westCell)
            }
            
            return cells
        }
    }
}

extension Cell {
    override var description: String {
        return "(row: \(row), column: \(column))"
    }
}

extension Cell {
    func dijkstra() -> Distances {
        var distances = Distances(root: self)
        var frontierCells = [self]

        while !frontierCells.isEmpty {
            var newFrontierCells = [Cell]()
            for cell in frontierCells {
                for linkedCell in cell.linkedCells {
                    if distances[linkedCell] != nil {
                        continue
                    }

                    distances[linkedCell] = (distances[cell] ?? 0) + 1
                    newFrontierCells.append(linkedCell)
                }
            }

            frontierCells = newFrontierCells
        }

        return distances
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
