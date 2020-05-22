//
//  PositionableTests.swift
//  MazesTests
//
//  Created by Marco Mussini on 21/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import XCTest
@testable import Mazes

class PositionableTests: XCTestCase {
    func testEmptyPositionable() {
        let positionable = PositionableFixture()
        XCTAssert(positionable.neighbors.count == 0)
        XCTAssertNil(positionable.get(.position0))
        XCTAssertNil(positionable.get(.position1))
        XCTAssertNil(positionable.get(.position2))
    }

    func testSetNeighbors() {
        let positionablePivot = PositionableFixture()
        let item0 = LinkableFixture(identifier: "item0")
        let item1 = LinkableFixture(identifier: "item1")
        let item2 = LinkableFixture(identifier: "item2")

        positionablePivot.set(item: item0, at: .position0)
        XCTAssertEqual(positionablePivot.get(.position0), item0)
        XCTAssertNil(positionablePivot.get(.position1))
        XCTAssertNil(positionablePivot.get(.position2))

        positionablePivot.set(item: item1, at: .position1)
        XCTAssertEqual(positionablePivot.get(.position0), item0)
        XCTAssertEqual(positionablePivot.get(.position1), item1)
        XCTAssertNil(positionablePivot.get(.position2))

        positionablePivot.set(item: item2, at: .position2)
        XCTAssertEqual(positionablePivot.get(.position0), item0)
        XCTAssertEqual(positionablePivot.get(.position1), item1)
        XCTAssertEqual(positionablePivot.get(.position2), item2)

        XCTAssertEqual(positionablePivot.neighbors.count, 3)
        XCTAssertTrue(positionablePivot.neighbors.contains(item0))
        XCTAssertTrue(positionablePivot.neighbors.contains(item1))
        XCTAssertTrue(positionablePivot.neighbors.contains(item2))
    }

    func testSettingNilNeighborRemovesIt() {
        let positionablePivot = PositionableFixture()
        let item0 = LinkableFixture()

        positionablePivot.set(item: item0, at: .position0)
        XCTAssertNotNil(positionablePivot.get(.position0))
        positionablePivot.set(item: nil, at: .position0)
        XCTAssertNil(positionablePivot.get(.position0))
        XCTAssertEqual(positionablePivot.neighbors.count, 0)
    }

    func testSameNeighborCannotBeSetInTwoDifferentPositions() {
        let positionablePivot = PositionableFixture()
        let item0 = LinkableFixture(identifier: "item0")

        positionablePivot.set(item: item0, at: .position0)
        XCTAssertEqual(positionablePivot.get(.position0), item0)
        positionablePivot.set(item: item0, at: .position1)
        XCTAssertNil(positionablePivot.get(.position0))
        XCTAssertEqual(positionablePivot.get(.position1), item0)
    }

    func testRemoveNeighbors() {
        let positionablePivot = PositionableFixture()
        let item0 = LinkableFixture(identifier: "item0")

        positionablePivot.set(item: item0, at: .position0)
        positionablePivot.remove(item: .position0)
        XCTAssertNil(positionablePivot.get(.position0))
    }
}

struct PositionableFixture: Positionable {
    typealias Position = CoordinatesFixture
    typealias Item = LinkableFixture

    public let positionableStorage = PositionableStorage<CoordinatesFixture, LinkableFixture>()
}

enum CoordinatesFixture: Positioning {
    case position0
    case position1
    case position2
}
