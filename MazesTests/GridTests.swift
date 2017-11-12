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
        XCTAssert(grid.rows == numberOfRows)
        XCTAssert(grid.columns == numberOfColumns)
        
        for row in 0...numberOfRows - 1 {
            for column in 0...numberOfColumns - 1 {
                let cell = grid.cellsMatrix[row][column]
                XCTAssert(cell.isKind(of: Cell.self))
                XCTAssert(cell.row == row)
                XCTAssert(cell.column == column)
            }
        }
        
        let cell2_2 = grid.cellsMatrix[2][2]
        XCTAssertNotNil(cell2_2.northCell)
        XCTAssertNotNil(cell2_2.southCell)
        XCTAssertNotNil(cell2_2.eastCell)
        XCTAssertNotNil(cell2_2.westCell)
        
        let cell0_0 = grid.cellsMatrix[0][0]
        XCTAssertNil(cell0_0.northCell)
        XCTAssertNotNil(cell0_0.southCell)
        XCTAssertNotNil(cell0_0.eastCell)
        XCTAssertNil(cell0_0.westCell)
        
        let cell4_0 = grid.cellsMatrix[4][0]
        XCTAssertNotNil(cell4_0.northCell)
        XCTAssertNil(cell4_0.southCell)
        XCTAssertNotNil(cell4_0.eastCell)
        XCTAssertNil(cell4_0.westCell)
        
        let cell4_9 = grid.cellsMatrix[4][9]
        XCTAssertNotNil(cell4_9.northCell)
        XCTAssertNil(cell4_9.southCell)
        XCTAssertNil(cell4_9.eastCell)
        XCTAssertNotNil(cell4_9.westCell)
        
        let cell0_9 = grid.cellsMatrix[0][9]
        XCTAssertNil(cell0_9.northCell)
        XCTAssertNotNil(cell0_9.southCell)
        XCTAssertNil(cell0_9.eastCell)
        XCTAssertNotNil(cell0_9.westCell)
        
        // FIXME: how to test the result of an algorithm?
        grid.binaryTreeGenerator()
    }
    
    func testCellAt() {
        let grid = Grid(rows: 5, columns: 10)
        XCTAssertNil(grid.cellAt(row: 5, column: 10))
        XCTAssertNil(grid.cellAt(row: -1, column: -1))
        XCTAssertNil(grid.cellAt(row: -1, column: 8))
        XCTAssertNil(grid.cellAt(row: 2, column: -1))
        let cell = grid.cellAt(row: 3, column: 3)
        XCTAssert((cell?.isKind(of: Cell.self))!)
    }
    
    // FIXME: can fail if random generation creates equal row/column
    func testRandomCell() {
        let grid = Grid(rows: 5, columns: 10)
        let randomCell1 = grid.randomCell()
        let randomCell2 = grid.randomCell()
        XCTAssert(randomCell1.isKind(of: Cell.self))
        XCTAssert(randomCell2.isKind(of: Cell.self))
        XCTAssert(randomCell1 != randomCell2)
    }
    
    func testAsAscii() {
        let mazeSize = 10
        let grid = Grid(rows: mazeSize, columns: mazeSize)
        grid.binaryTreeGenerator()
        print(grid.asAscii())
    }
}
