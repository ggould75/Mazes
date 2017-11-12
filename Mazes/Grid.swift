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
                let cell = cellAt(row: row, column: column)
                cell?.northCell = cellAt(row: row - 1, column: column)
                cell?.southCell = cellAt(row: row + 1, column: column)
                cell?.westCell = cellAt(row: row, column: column - 1)
                cell?.eastCell = cellAt(row: row, column: column + 1)
            }
        }
    }
    
    public func cellAt(row: Int, column: Int) -> Cell! {
        guard row >= 0 && row < rows &&
              column >= 0 && column < columns else
        {
            return nil
        }

        return cellsMatrix[row][column];
    }
    
    public func randomCell() -> Cell {
        return cellAt(row: Int(arc4random_uniform(UInt32(rows))), column: Int(arc4random_uniform(UInt32(columns))))
    }
    
    public func binaryTreeGenerator() {
        for rowArray in cellsMatrix {
            for cell in rowArray {
                print("row: \(cell.row), column: \(cell.column)")
                var neighbors = [Cell]()
                if cell.northCell != nil {
                    neighbors.append(cell.northCell)
                }
                if cell.eastCell != nil {
                    neighbors.append(cell.eastCell)
                }
                
                if neighbors.count == 0 {
                    continue
                }
                var randomNeighborIndex = 0
                if neighbors.count == 2 {
                    randomNeighborIndex = Int(arc4random_uniform(UInt32(neighbors.count)))
                }
                
                let randomNeighbor = neighbors[randomNeighborIndex] as Cell
                cell.link(toCell: randomNeighbor)
            }
        }
    }
}
