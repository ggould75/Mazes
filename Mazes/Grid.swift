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
    public var cellsMatrix: Array<Array<Cell>> = []
    
    public init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        super.init()
        setupCellsMatrix()
        setupCellsNeighbors()
    }
    
    private func setupCellsMatrix() {
        for row in 0...rows - 1 {
            cellsMatrix.append([Cell]())
            for column in 0...columns - 1 {
                let cell = Cell(row: row, column: column)
                cellsMatrix[row].append(cell)
            }
        }
    }
    
    private func setupCellsNeighbors() {
        for row in 0...rows - 1 {
            for column in 0...columns - 1 {
                let cell = cellsMatrix[row][column]
                if row - 1 >= 0 {
                    cell.northCell = cellsMatrix[row - 1][column]
                }
                if row + 1 < rows {
                    cell.southCell = cellsMatrix[row + 1][column]
                }
                if column - 1 >= 0 {
                    cell.westCell = cellsMatrix[row][column - 1]
                }
                if column + 1 < columns {
                    cell.eastCell = cellsMatrix[row][column + 1]
                }
            }
        }
    }
    
    public func cellAt(row: Int, column: Int) -> Cell! {
        guard row >= 0 && row < rows ||
              column >= 0 && column < columns else
        {
            return nil
        }

        return cellsMatrix[row][column];
    }
    
    public func randomCell() -> Cell {
        return cellAt(row: Int(arc4random_uniform(UInt32(rows - 1))), column: Int(arc4random_uniform(UInt32(columns - 1))))
    }
}
