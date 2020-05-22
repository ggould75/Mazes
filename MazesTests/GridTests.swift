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

    func testGridSetup() {
        let numberOfRows: UInt = 5
        let numberOfColumns: UInt = 8
        let grid = Grid(rows: numberOfRows, columns: numberOfColumns)

        XCTAssertEqual(grid.numberOfRows, numberOfRows)
        XCTAssertEqual(grid.numberOfColumns, numberOfColumns)
    }

    func testSubscriptGet() {
        let numberOfRows: UInt = 3
        let numberOfColumns: UInt = 6
        let grid = Grid(rows: numberOfRows, columns: numberOfColumns)

        for row in 0...numberOfRows - 1 {
            for column in 0...numberOfColumns - 1 {
                let cell = grid[Int(row), Int(column)]
                XCTAssert(cell?.row == row)
                XCTAssert(cell?.column == column)
            }
        }
    }

    func testSubscriptGet_OutOfBounds() {
        let numberOfRows: UInt = 3
        let numberOfColumns: UInt = 6
        let grid = Grid(rows: numberOfRows, columns: numberOfColumns)

        let rowIndexOutOfBoundCell = grid[3, 0]
        XCTAssertNil(rowIndexOutOfBoundCell)
        let columnIndexOutOfBoundCell = grid[0, 6]
        XCTAssertNil(columnIndexOutOfBoundCell)
        let bothIndexesOutOfBoundCell = grid[-1, -1]
        XCTAssertNil(bothIndexesOutOfBoundCell)
    }

    func testSubscriptSet() {
        let rows = 3
        let columns = 6
        var grid = Grid(rows: UInt(rows), columns: UInt(columns))

        let cell10_5 = Cell(10, 5)
        grid[0, 0] = cell10_5
        XCTAssertEqual(grid[0, 0], cell10_5)

        let cell2_5 = Cell(2, 5)
        grid[2, 5] = cell2_5
        XCTAssertEqual(grid[2, 5], cell2_5)
    }

    func testSubscriptSet_OutOfBounds() {
        let rows = 3
        let columns = 6
        var grid = Grid(rows: UInt(rows), columns: UInt(columns))

        // Trying to set a cell at Out Of Bounds indexes
        grid[rows, columns] = Cell(UInt(rows), UInt(columns))
        XCTAssertNil(grid[rows, columns])
        grid[0, columns] = Cell(0, UInt(columns))
        XCTAssertNil(grid[0, columns])
        grid[rows, 0] = Cell(UInt(rows), 0)
        XCTAssertNil(grid[rows, 0])
        grid[-1, -1] = Cell(0, 0)
        XCTAssertNil(grid[-1, -1])
    }

    func testNeighborCellsExpectedLayout() {
        let grid = Grid(rows: 5, columns: 10)

        let centralCell = grid[2, 2]
        XCTAssertEqual(centralCell?.get(.north), grid[1, 2])
        XCTAssertEqual(centralCell?.get(.south), grid[3, 2])
        XCTAssertEqual(centralCell?.get(.west), grid[2, 1])
        XCTAssertEqual(centralCell?.get(.east), grid[2, 3])

        let topLeftCell = grid[0, 0]
        XCTAssertNil(topLeftCell?.get(.north))
        XCTAssertEqual(topLeftCell?.get(.south), grid[1, 0])
        XCTAssertNil(topLeftCell?.get(.west))
        XCTAssertEqual(topLeftCell?.get(.east), grid[0, 1])

        let topRightCell = grid[0, 9]
        XCTAssertNil(topRightCell?.get(.north))
        XCTAssertEqual(topRightCell?.get(.south), grid[1, 9])
        XCTAssertEqual(topRightCell?.get(.west), grid[0, 8])
        XCTAssertNil(topRightCell?.get(.east))

        let bottomRightCell = grid[4, 9]
        XCTAssertEqual(bottomRightCell?.get(.north), grid[3, 9])
        XCTAssertNil(bottomRightCell?.get(.south))
        XCTAssertEqual(bottomRightCell?.get(.west), grid[4, 8])
        XCTAssertNil(bottomRightCell?.get(.east))

        let bottomLeftCell = grid[4, 0]
        XCTAssertEqual(bottomLeftCell?.get(.north), grid[3, 0])
        XCTAssertNil(bottomLeftCell?.get(.south))
        XCTAssertNil(bottomLeftCell?.get(.west))
        XCTAssertEqual(bottomLeftCell?.get(.east), grid[4, 1])
    }
}
