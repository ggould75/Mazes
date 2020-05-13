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
        let cell = Cell(0, 0)
        XCTAssert(cell.row == 0)
        XCTAssert(cell.column == 0)
        XCTAssert(type(of: cell.linked) == Set<Cell>.self)
        XCTAssert(cell.linked.count == 0)
        XCTAssert(type(of: cell.neighbours) == Set<Cell>.self)
        XCTAssert(cell.neighbours.count == 0)
    }
    
    func testLinks() {
        var cell = Cell(0, 0)
        var cell2 = Cell(0, 1)
        
        cell.link(toCell: &cell2, bidirectional: true)
        cell.link(toCell: &cell2, bidirectional: true)
        XCTAssert(cell.linked.contains(cell2))
        XCTAssert(cell.linked.count == 1)
        XCTAssert(cell2.linked.contains(cell))
        XCTAssert(cell2.linked.count == 1)
        
        cell.unlink(fromCell: &cell2, bidirectional: false)
        XCTAssertFalse(cell.linked.contains(cell2))
        XCTAssert(cell.linked.count == 0)
        XCTAssert(cell2.linked.contains(cell))
        XCTAssert(cell2.linked.count == 1)
        
        cell.unlink(fromCell: &cell2, bidirectional: true)
        cell.unlink(fromCell: &cell2, bidirectional: true)
        XCTAssertFalse(cell2.linked.contains(cell))
        XCTAssert(cell2.linked.count == 0)
        
        cell.link(toCell: &cell2, bidirectional: false)
        XCTAssert(cell.linked.contains(cell2))
        XCTAssert(cell.linked.count == 1)
        XCTAssertFalse(cell2.linked.contains(cell))
        XCTAssert(cell2.linked.count == 0)
        
        XCTAssert(cell.isLinkedTo(cell: cell2))
        cell.unlink(fromCell: &cell2, bidirectional: true)
        XCTAssertFalse(cell.isLinkedTo(cell: cell2))
    }
    
    func testNeighbors() {
        var cell = Cell(2, 2)
        
        XCTAssert(cell.neighbours.count == 0)
        XCTAssertNil(cell.get(position: .north))
        XCTAssertNil(cell.get(position: .south))
        XCTAssertNil(cell.get(position: .east))
        XCTAssertNil(cell.get(position: .west))
        
        let northCell = Cell(1, 2)
        let southCell = Cell(3, 2)
        let eastCell = Cell(2, 1)
        let westCell = Cell(2, 3)
        cell.set(position: .north, item: northCell)
        cell.set(position: .south, item: southCell)
        cell.set(position: .east, item: eastCell)
        cell.set(position: .west, item: westCell)
        XCTAssertEqual(cell.get(position: .north), northCell)
        XCTAssertEqual(cell.get(position: .south), southCell)
        XCTAssertEqual(cell.get(position: .east), eastCell)
        XCTAssertEqual(cell.get(position: .west), westCell)
        XCTAssert(cell.neighbours.count == 4)
        XCTAssert(cell.neighbours.contains(northCell))
        XCTAssert(cell.neighbours.contains(southCell))
        XCTAssert(cell.neighbours.contains(eastCell))
        XCTAssert(cell.neighbours.contains(westCell))
    }
    
    func testNeighborCellsAreSetCorrectly() {
        let grid = Grid(rows: 5, columns: 10)
        
        // neighbors of middle cell
        let cell2_2 = grid.cellAt(row: 2, column: 2)
        XCTAssertEqual(cell2_2?.get(position: .north), grid.cellAt(row: 1, column: 2))
        XCTAssertEqual(cell2_2?.get(position: .south), grid.cellAt(row: 3, column: 2))
        XCTAssertEqual(cell2_2?.get(position: .west), grid.cellAt(row: 2, column: 1))
        XCTAssertEqual(cell2_2?.get(position: .east), grid.cellAt(row: 2, column: 3))
        
        // top-left cell
        let cell0_0 = grid.cellAt(row: 0, column: 0)
        XCTAssertNil(cell0_0?.get(position: .north))
        XCTAssertEqual(cell0_0?.get(position: .south), grid.cellAt(row: 1, column: 0))
        XCTAssertNil(cell0_0?.get(position: .west))
        XCTAssertEqual(cell0_0?.get(position: .east), grid.cellAt(row: 0, column: 1))
        
        // top-right cell
        let cell0_9 = grid.cellAt(row: 0, column: 9)
        XCTAssertNil(cell0_9?.get(position: .north))
        XCTAssertEqual(cell0_9?.get(position: .south), grid.cellAt(row: 1, column: 9))
        XCTAssertEqual(cell0_9?.get(position: .west), grid.cellAt(row: 0, column: 8))
        XCTAssertNil(cell0_9?.get(position: .east))
        
        // bottom-right cell
        let cell4_9 = grid.cellAt(row: 4, column: 9)
        XCTAssertEqual(cell4_9?.get(position: .north), grid.cellAt(row: 3, column: 9))
        XCTAssertNil(cell4_9?.get(position: .south))
        XCTAssertEqual(cell4_9?.get(position: .west), grid.cellAt(row: 4, column: 8))
        XCTAssertNil(cell4_9?.get(position: .east))
        
        // bottom-left cell
        let cell4_0 = grid.cellAt(row: 4, column: 0)
        XCTAssertEqual(cell4_0?.get(position: .north), grid.cellAt(row: 3, column: 0))
        XCTAssertNil(cell4_0?.get(position: .south))
        XCTAssertNil(cell4_0?.get(position: .west))
        XCTAssertEqual(cell4_0?.get(position: .east), grid.cellAt(row: 4, column: 1))
    }

    func testDijkstra() {
        let grid = Grid(rows: 5, columns: 5)
        grid.buildSidewinderMaze()
        let rootCell = grid.cellAt(row: 0, column: 0)
        print("\(String(describing: rootCell?.dijkstra().distances))")
    }

    func testTopWallAsAscii() {
        // No north cell
        var cell0_0 = Cell(0, 0)
        XCTAssertEqual(cell0_0.topWallAsAscii(), "+---")
        
        // North cell but not linked
        var cell1_0 = Cell(1, 0)
        cell1_0.set(position: .north, item: cell0_0)
        XCTAssertEqual(cell1_0.topWallAsAscii(), "+---")
        
        // North cell linked
        cell1_0.link(toCell: &cell0_0, bidirectional: true)
        XCTAssertEqual(cell1_0.topWallAsAscii(), "+   ")
    }
    
    func testBodyAsAscii() {
        // No west cell
        var cell0_0 = Cell(0, 0)
        XCTAssertEqual(cell0_0.bodyAsAscii(), "|   ")
        
        // West cell but not linked
        var cell0_1 = Cell(0, 1)
        cell0_1.set(position: .west, item: cell0_0)
        XCTAssertEqual(cell0_1.bodyAsAscii(), "|   ")
        
        // West cell linked
        cell0_1.link(toCell: &cell0_0, bidirectional: true)
        XCTAssertEqual(cell0_1.bodyAsAscii(), "    ")
    }
    
    func testBottomWallAsAscii() {
        // No south cell
        var cell1_0 = Cell(1, 0)
        XCTAssertEqual(cell1_0.bottomWallAsAscii(), "+---")
        
        // South cell but not linked
        var cell0_0 = Cell(0, 0)
        cell0_0.set(position: .south, item: cell1_0)
        XCTAssertEqual(cell0_0.bottomWallAsAscii(), "+---")
        
        // South cell linked
        cell0_0.link(toCell: &cell1_0, bidirectional: true)
        XCTAssertEqual(cell0_0.bottomWallAsAscii(), "+   ")
    }
}
