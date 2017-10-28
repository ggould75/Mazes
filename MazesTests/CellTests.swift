//
//  CellTests.swift
//  MazesTests
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import XCTest
@testable import Mazes

class CellTests: XCTestCase {
    func testInit() {
        let cell = Cell(row: 0, column: 0)
        XCTAssert(cell.row == 0)
        XCTAssert(cell.column == 0)
        XCTAssert(cell.linkedCells.isKind(of: NSMutableSet.self))
        XCTAssert(cell.linkedCells.count == 0)
    }
    
    func testLinks() {
        let cell = Cell(row: 0, column: 0)
        let cell2 = Cell(row: 0, column: 1)
        
        cell.link(toCell: cell2)
        cell.link(toCell: cell2)
        XCTAssert(cell.linkedCells.contains(cell2))
        XCTAssert(cell.linkedCells.count == 1)
        XCTAssert(cell2.linkedCells.contains(cell))
        XCTAssert(cell2.linkedCells.count == 1)
        
        cell.unlink(fromCell: cell2, bidirectional: false)
        XCTAssertFalse(cell.linkedCells.contains(cell2))
        XCTAssert(cell.linkedCells.count == 0)
        XCTAssert(cell2.linkedCells.contains(cell))
        XCTAssert(cell2.linkedCells.count == 1)
        
        cell.unlink(fromCell: cell2)
        cell.unlink(fromCell: cell2)
        XCTAssertFalse(cell2.linkedCells.contains(cell))
        XCTAssert(cell2.linkedCells.count == 0)
        
        cell.link(toCell: cell2, bidirectional: false)
        XCTAssert(cell.linkedCells.contains(cell2))
        XCTAssert(cell.linkedCells.count == 1)
        XCTAssertFalse(cell2.linkedCells.contains(cell))
        XCTAssert(cell2.linkedCells.count == 0)
        
        XCTAssert(cell.isLinkedToCell(cell: cell2))
        cell.unlink(fromCell: cell2)
        XCTAssertFalse(cell.isLinkedToCell(cell: cell2))
    }
    
    }
}
