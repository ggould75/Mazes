//
//  LinkableTests.swift
//  MazesTests
//
//  Created by Marco Mussini on 18/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import XCTest
@testable import Mazes

class LinkableTests: XCTestCase {
    func testLinkable() {
        let linkable = LinkableFixture()
        XCTAssertTrue(type(of: linkable.linked) == LinkableSet.self)
        XCTAssertEqual(linkable.linked.count, 0)
    }

    func testBidirectionalLink() {
        let item0 = LinkableFixture(identifier: "item0")
        let item1 = LinkableFixture(identifier: "item1")

        item0.link(to: item1)

        XCTAssertEqual(item0.linked.count, 1)
        XCTAssertEqual(item1.linked.count, 1)
        XCTAssertEqual(item0.linked.first, item1)
        XCTAssertEqual(item0.linked.first?.hashValue, item1.hashValue)
        XCTAssertEqual(item1.linked.first, item0)
        XCTAssertEqual(item1.linked.first?.hashValue, item0.hashValue)
    }

    func testUnidirectionalLink() {
        let item0 = LinkableFixture(identifier: "item0")
        let item1 = LinkableFixture(identifier: "item1")

        item0.link(to: item1, bidirectional: false)

        XCTAssertEqual(item0.linked.count, 1)
        XCTAssertEqual(item1.linked.count, 0)
        XCTAssertEqual(item0.linked.first, item1)
    }

    func testBidirectionalUnlink() {
        let item0 = LinkableFixture(identifier: "item0")
        let item1 = LinkableFixture(identifier: "item1")

        item0.link(to: item1)
        item0.unlink(from: item1)

        XCTAssertEqual(item0.linked.count, 0)
        XCTAssertEqual(item1.linked.count, 0)
    }

    func testUnidirectionalUnlink() {
        let item0 = LinkableFixture(identifier: "item0")
        let item1 = LinkableFixture(identifier: "item1")

        item0.link(to: item1, bidirectional: true)
        item0.unlink(from: item1, bidirectional: false)

        XCTAssertEqual(item0.linked.count, 0)
        XCTAssertEqual(item1.linked.count, 1)
        XCTAssertEqual(item1.linked.first, item0)

        item1.unlink(from: item0, bidirectional: false)
        XCTAssertEqual(item1.linked.count, 0)
    }

    func testIsLinkedTo() {
        let item0 = LinkableFixture(identifier: "item0")
        let item1 = LinkableFixture(identifier: "item1")

        item0.link(to: item1)

        XCTAssertTrue(item0.isLinkedTo(item1))
        XCTAssertTrue(item1.isLinkedTo(item0))

        item0.unlink(from: item1, bidirectional: false)
        XCTAssertFalse(item0.isLinkedTo(item1))
        XCTAssertTrue(item1.isLinkedTo(item0))

        item1.unlink(from: item0, bidirectional: false)
        XCTAssertFalse(item0.isLinkedTo(item1))
        XCTAssertFalse(item1.isLinkedTo(item0))

        XCTAssertFalse(item0.isLinkedTo(nil))
    }
}
