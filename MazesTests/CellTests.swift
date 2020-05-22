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
        let cell0 = Cell(0, 0)
        XCTAssert(cell0.row == 0)
        XCTAssert(cell0.column == 0)
        XCTAssert(cell0.neighbors.count == 0)

        let cell1 = Cell(10, 5)
        XCTAssert(cell1.row == 10)
        XCTAssert(cell1.column == 5)
    }

    func testBidirectionalLink() {
        let cell0 = Cell(0, 0)
        let cell1 = Cell(0, 1)

        cell0.link(to: cell1)

        XCTAssertEqual(cell0.linked.count, 1)
        XCTAssertEqual(cell1.linked.count, 1)
        XCTAssertEqual(cell0.linked.first, cell1)
        XCTAssertEqual(cell0.linked.first?.hashValue, cell1.hashValue)
        XCTAssertEqual(cell1.linked.first, cell0)
        XCTAssertEqual(cell1.linked.first?.hashValue, cell0.hashValue)
    }

    func testUnidirectionalLink() {
        let cell0 = Cell(0, 0)
        let cell1 = Cell(0, 1)

        cell0.link(to: cell1, bidirectional: false)

        XCTAssertEqual(cell0.linked.count, 1)
        XCTAssertEqual(cell1.linked.count, 0)
        XCTAssertEqual(cell0.linked.first, cell1)
    }

    func testBidirectionalUnlink() {
        let cell0 = Cell(0, 0)
        let cell1 = Cell(0, 1)

        cell0.link(to: cell1)
        cell0.unlink(from: cell1)

        XCTAssertEqual(cell0.linked.count, 0)
        XCTAssertEqual(cell1.linked.count, 0)
    }

    func testUnidirectionalUnlink() {
        let cell0 = Cell(0, 0)
        let cell1 = Cell(0, 1)

        cell0.link(to: cell1, bidirectional: true)
        cell0.unlink(from: cell1, bidirectional: false)

        XCTAssertEqual(cell0.linked.count, 0)
        XCTAssertEqual(cell1.linked.count, 1)
        XCTAssertEqual(cell1.linked.first, cell0)

        cell1.unlink(from: cell0, bidirectional: false)
        XCTAssertEqual(cell1.linked.count, 0)
    }

    func testCellCannotBeLinkedTwice() {
        let cellPivot = Cell(0, 0)
        let cell = Cell(0, 1)

        cellPivot.link(to: cell)
        cellPivot.link(to: cell)

        XCTAssertEqual(cellPivot.linked.count, 1)
        XCTAssertEqual(cell.linked.count, 1)
        XCTAssertTrue(cellPivot.linked.contains(cell))
        XCTAssertTrue(cell.linked.contains(cellPivot))
    }

    func testNeighborsLayout() {
        let cellPivot = Cell(2, 2)

        XCTAssertNil(cellPivot.get(.north))
        XCTAssertNil(cellPivot.get(.south))
        XCTAssertNil(cellPivot.get(.east))
        XCTAssertNil(cellPivot.get(.west))

        let northCell = Cell(1, 2)
        let southCell = Cell(3, 2)
        let eastCell = Cell(2, 1)
        let westCell = Cell(2, 3)

        cellPivot.set(item: northCell, at: .north)
        cellPivot.set(item: southCell, at: .south)
        cellPivot.set(item: eastCell, at: .east)
        cellPivot.set(item: westCell, at: .west)

        XCTAssertEqual(cellPivot.get(.north), northCell)
        XCTAssertEqual(cellPivot.get(.south), southCell)
        XCTAssertEqual(cellPivot.get(.east), eastCell)
        XCTAssertEqual(cellPivot.get(.west), westCell)
        XCTAssertEqual(cellPivot.neighbors.count, 4)
        XCTAssertTrue(cellPivot.neighbors.contains(northCell))
        XCTAssertTrue(cellPivot.neighbors.contains(southCell))
        XCTAssertTrue(cellPivot.neighbors.contains(eastCell))
        XCTAssertTrue(cellPivot.neighbors.contains(westCell))
    }
}
