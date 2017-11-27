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
    
    public func sidewinderGenerator() {
        for rowArray in cellsMatrix {
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
    
    public func asAscii() -> String {
        var output = ""
        var topWallOutput = ""
        var bottomWallOutput = ""
        var bodyWallOutput = ""
        var rowIndex = 0
        var columnIndex = 0
        for rowArray in cellsMatrix {
            columnIndex = 0
            for cell in rowArray {
                topWallOutput += cell.topWallAsAscii()
                bodyWallOutput += cell.bodyAsAscii()
                
                let isLastRow = rowIndex == cellsMatrix.count - 1
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
    
    override var description : String {
        return asAscii()
    }
}
