//
//  MazeBuildersTests.swift
//  MazesTests
//
//  Created by Marco Mussini on 22/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import XCTest
@testable import Mazes

// TODO: Refactor

class MazeBuildersTests: XCTestCase {

    func testMazeRandomGenerators() {
        var grid = Grid(rows: 10, columns: 10)
        grid.buildBinaryTreeMaze()
        var asciiGrid = grid.asAscii()
        print("Binary tree generated maze:\n\(asciiGrid)\n\n")

        grid = Grid(rows: 10, columns: 10)
        grid.buildSidewinderMaze()
        asciiGrid = grid.asAscii()
        print("Sidewinder generated maze:\n\(asciiGrid)")
    }

    func testDijkstra() {
        let grid = Grid(rows: 5, columns: 5)
        grid.buildSidewinderMaze()
        let rootCell = grid[0, 0]
        print("\(String(describing: rootCell?.dijkstra().distances))")
    }

    func testTopWallAsAscii() {
        // No north cell
        let cell0_0 = Cell(0, 0)
        XCTAssertEqual(cell0_0.topWallAsAscii(), "+---")

        // North cell but not linked
        let cell1_0 = Cell(1, 0)
        cell1_0.set(item: cell0_0, at: .north)
        XCTAssertEqual(cell1_0.topWallAsAscii(), "+---")

        // North cell linked
        cell1_0.link(to: cell0_0)
        XCTAssertEqual(cell1_0.topWallAsAscii(), "+   ")
    }

    func testBodyAsAscii() {
        // No west cell
        let cell0_0 = Cell(0, 0)
        XCTAssertEqual(cell0_0.bodyAsAscii(), "|   ")

        // West cell but not linked
        let cell0_1 = Cell(0, 1)
        cell0_1.set(item: cell0_0, at: .west)
        XCTAssertEqual(cell0_1.bodyAsAscii(), "|   ")

        // West cell linked
        cell0_1.link(to: cell0_0)
        XCTAssertEqual(cell0_1.bodyAsAscii(), "    ")
    }

    func testBottomWallAsAscii() {
        // No south cell
        let cell1_0 = Cell(1, 0)
        XCTAssertEqual(cell1_0.bottomWallAsAscii(), "+---")

        // South cell but not linked
        let cell0_0 = Cell(0, 0)
        cell0_0.set(item: cell1_0, at: .south)
        XCTAssertEqual(cell0_0.bottomWallAsAscii(), "+---")

        // South cell linked
        cell0_0.link(to: cell1_0)
        XCTAssertEqual(cell0_0.bottomWallAsAscii(), "+   ")
    }
}

extension Grid: CustomStringConvertible {
    public var description: String {
        return asAscii()
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

extension Cell {
    func topWallAsAscii() -> String {
        guard let northCell = get(.north), isLinkedTo(northCell) else {
            return "+---"
        }

        return "+   "
    }

    func bodyAsAscii() -> String {
        guard let westCell = get(.west), isLinkedTo(westCell) else {
            return "|   "
        }

        return "    "
    }

    func bottomWallAsAscii() -> String {
        guard let southCell = get(.south), isLinkedTo(southCell) else {
            return "+---"
        }

        return "+   "
    }
}
