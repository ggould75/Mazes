//
//  GridTests.swift
//  MazesTests
//
//  Created by Marco Mussini on 28/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import XCTest
@testable import Mazes

class GridTests: XCTestCase {
    func testInit() {
        let numberOfRows = 5
        let numberOfColumns = 10
        let grid = Grid(rows: numberOfRows, columns: numberOfColumns)
        XCTAssert(grid.rows == 5)
        XCTAssert(grid.columns == 10)
        
        for row in 0...numberOfRows - 1 {
            for column in 0...numberOfColumns - 1 {
                let cell = grid.cellsMatrix[row][column]
                XCTAssert(cell.isKind(of: Cell.self))
                XCTAssert(cell.row == row)
                XCTAssert(cell.column == column)
            }
        }
    }
}
