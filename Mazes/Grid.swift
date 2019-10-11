//
//  Grid.swift
//  Mazes
//
//  Created by Marco Mussini on 28/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import UIKit

struct Grid {
    let numberOfRows: Int
    let numberOfColumns: Int
    var cells: [[Cell]] = []

    init(rows: Int, columns: Int) {
        self.numberOfRows = rows
        self.numberOfColumns = columns
        setupCells()
        setupCellsNeighbors()
    }
    
    private mutating func setupCells() {
        for row in 0...numberOfRows - 1 {
            let columns = (0...numberOfColumns - 1).map { Cell(row: row, column: $0) }
            cells.append(columns)
        }
    }
    
    private func setupCellsNeighbors() {
        for (rowIdx, rowCells) in cells.enumerated() {
            for (columnIdx, cell) in rowCells.enumerated() {
                cell.northCell = cellAt(row: rowIdx - 1, column: columnIdx)
                cell.southCell = cellAt(row: rowIdx + 1, column: columnIdx)
                cell.westCell = cellAt(row: rowIdx, column: columnIdx - 1)
                cell.eastCell = cellAt(row: rowIdx, column: columnIdx + 1)
            }
        }
    }
    
    func cellAt(row: Int, column: Int) -> Cell? {
        guard 0..<numberOfRows ~= row,
              0..<numberOfColumns ~= column else {

            return nil
        }

        return cells[row][column];
    }
    
    func randomCell() -> Cell? {
        return cellAt(row: numberOfRows.randomize(),
                      column: numberOfColumns.randomize())
    }
    
    func binaryTreeGenerator() {
        for rowArray in cells {
            for cell in rowArray {
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
    
    func sidewinderGenerator() {
        for rowArray in cells {
            var run = [Cell]()
            for cell in rowArray {
                run.append(cell)
                
                let isAtEastBoundary = (cell.eastCell == nil)
                let isAtNorthBoundary = (cell.northCell == nil)
                let randomDirection = Int(arc4random_uniform(UInt32(2)))
                let shouldCloseOutRun = isAtEastBoundary || (!isAtNorthBoundary && randomDirection == 0)
                
                if shouldCloseOutRun {
                    let randomRunMemberIndex = Int(arc4random_uniform(UInt32(run.count)))
                    let runMemberCell = run[randomRunMemberIndex]
                    if (runMemberCell.northCell != nil) {
                        runMemberCell.link(toCell: runMemberCell.northCell)
                    }
                    
                    run.removeAll()
                }
                else {
                    cell.link(toCell: cell.eastCell)
                }
            }
        }
    }
    
    func asAscii() -> String {
        var output = ""
        var topWallOutput = ""
        var bottomWallOutput = ""
        var bodyWallOutput = ""
        var rowIndex = 0
        var columnIndex = 0
        for rowArray in cells {
            columnIndex = 0
            for cell in rowArray {
                topWallOutput += cell.topWallAsAscii()
                bodyWallOutput += cell.bodyAsAscii()
                
                let isLastRow = rowIndex == cells.count - 1
                if (isLastRow) {
                    bottomWallOutput += cell.bottomWallAsAscii()
                }
                
                let isLastColumn = columnIndex == rowArray.count - 1
                if (isLastColumn) {
                    topWallOutput += "+"
                    bodyWallOutput += "|"
                }
                
                columnIndex = columnIndex + 1
            }
            
            output += topWallOutput + "\n" + bodyWallOutput + "\n"
            topWallOutput = ""
            bodyWallOutput = ""
            rowIndex = rowIndex + 1
        }
        
        output += bottomWallOutput + "+"
        
        return output
    }
    
    var description : String {
        return asAscii()
    }
}

extension Int {
    func randomize() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
