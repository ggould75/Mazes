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
        let grid = Grid(rows: 5, columns: 10)
        XCTAssert(grid.rows == 5)
        XCTAssert(grid.columns == 10)
    }
}
