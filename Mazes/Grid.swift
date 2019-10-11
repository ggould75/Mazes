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

    var description : String {
        return asAscii()
    }
}

extension Grid {
    func buildBinaryTreeMaze() {
        for rowCells in cells {
            for cell in rowCells {
                var neighbors = [Cell]()
                if let northCell = cell.northCell {
                    neighbors.append(northCell)
                }
                if let eastCell = cell.eastCell {
                    neighbors.append(eastCell)
                }

                if neighbors.count == 0 {
                    continue
                }

                var randomNeighborIndex = 0
                if neighbors.count == 2 {
                    randomNeighborIndex = neighbors.count.randomize()
                }

                let randomNeighbor = neighbors[randomNeighborIndex]
                cell.link(toCell: randomNeighbor)
            }
        }
    }

    func buildSidewinderMaze() {
        for rowCells in cells {
            var run = [Cell]()
            for cell in rowCells {
                run.append(cell)

                let isAtEastBoundary = cell.eastCell == nil
                let isAtNorthBoundary = cell.northCell == nil
                let randomDirection = 2.randomize()
                let shouldCloseOutRun =
                    isAtEastBoundary || (!isAtNorthBoundary && randomDirection == 0)

                if shouldCloseOutRun {
                    let randomRunMemberIndex = run.count.randomize()
                    let runMemberCell = run[randomRunMemberIndex]
                    if let runMemberNorthCell = runMemberCell.northCell {
                        runMemberCell.link(toCell: runMemberNorthCell)
                    }

                    run.removeAll()
                }
                else if let eastCell = cell.eastCell {
                    cell.link(toCell: eastCell)
                }
            }
        }
    }
}

extension Grid {
    func asAscii() -> String {
        var output = ""
        var topWallOutput = ""
        var bottomWallOutput = ""
        var bodyWallOutput = ""
        var rowIndex = 0
        var columnIndex = 0

        for rowCells in cells {
            columnIndex = 0
            for cell in rowCells {
                topWallOutput += cell.topWallAsAscii()
                bodyWallOutput += cell.bodyAsAscii()

                let isLastRow = rowIndex == cells.count - 1
                if (isLastRow) {
                    bottomWallOutput += cell.bottomWallAsAscii()
                }

                let isLastColumn = columnIndex == rowCells.count - 1
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
}

extension Int {
    func randomize() -> Int {
        return Int(arc4random_uniform(UInt32(self)))
    }
}
