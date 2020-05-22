//
//  Grid.swift
//  Mazes
//
//  Created by Marco Mussini on 28/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import Foundation

// FIXME: make Grid enumerable so I can avoid exposing cells
// Space: O(r*c) = O(V), where V is number of cells
struct Grid {
    var cells: [[Cell]] = []

    let numberOfRows: UInt
    let numberOfColumns: UInt

    // Time: O(2V) = O(V)
    init(rows: UInt, columns: UInt) {
        self.numberOfRows = rows
        self.numberOfColumns = columns
        setupCells()
        setupCellsNeighbors()
    }

    // Time: O(r*c) = O(V)
    private mutating func setupCells() {
        for row in 0...numberOfRows - 1 {
            let columns = (0...numberOfColumns - 1).map { Cell(row, $0) }
            cells.append(columns)
        }
    }

    // Time: O(r*c) = O(V)
    private func setupCellsNeighbors() {
        for (rowIdx, rowCells) in cells.enumerated() {
            for (columnIdx, cell) in rowCells.enumerated() {
                cell.set(item: self[rowIdx - 1, columnIdx],
                         at: .north)
                cell.set(item: self[rowIdx + 1, columnIdx],
                         at: .south)
                cell.set(item: self[rowIdx, columnIdx - 1],
                         at: .west)
                cell.set(item: self[rowIdx, columnIdx + 1],
                         at: .east)
            }
        }
    }

    subscript(row: Int, column: Int) -> Cell? {
        get {
            return indexIsValid(row: row, column: column)
                        ? cells[row][column]
                        : nil
        }
        set {
            if let newValue = newValue, indexIsValid(row: row, column: column) {
                cells[row][column] = newValue
            }
        }
    }

    private func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < numberOfRows &&
               column >= 0 && column < numberOfColumns
    }
}
