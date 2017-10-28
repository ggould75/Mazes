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
        XCTAssertEqual(cell.row == 0)
        XCTAssert(cell.column == 0)
        XCTAssert(cell.linkedCells.isKind(of: NSMutableSet.self))
        XCTAssert(cell.linkedCells.count == 0)
        XCTAssert(cell.neighborCells.isKind(of: NSSet.self))
        XCTAssert(cell.neighborCells.count == 0)
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
    
    func testNeighbors() {
        let cell = Cell(row: 2, column: 2)
        
        XCTAssert(cell.neighborCells.count == 0)
        XCTAssertNil(cell.northCell)
        XCTAssertNil(cell.southCell)
        XCTAssertNil(cell.eastCell)
        XCTAssertNil(cell.westCell)
        
        let northCell = Cell(row: 1, column: 2)
        let southCell = Cell(row: 3, column: 2)
        let eastCell = Cell(row: 2, column: 1)
        let westCell = Cell(row: 2, column: 3)
        cell.northCell = northCell
        cell.southCell = southCell
        cell.eastCell = eastCell
        cell.westCell = westCell
        XCTAssertEqual(cell.northCell, northCell)
        XCTAssertEqual(cell.northCell, northCell)
        XCTAssertEqual(cell.southCell, southCell)
        XCTAssertEqual(cell.eastCell, eastCell)
        XCTAssertEqual(cell.westCell, westCell)
        XCTAssert(cell.neighborCells.count == 4)
        XCTAssert(cell.neighborCells.contains(northCell))
        XCTAssert(cell.neighborCells.contains(southCell))
        XCTAssert(cell.neighborCells.contains(eastCell))
        XCTAssert(cell.neighborCells.contains(westCell))
    }
}
