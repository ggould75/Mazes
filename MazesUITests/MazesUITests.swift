//
//  MazesUITests.swift
//  MazesUITests
//
//  Created by Marco Mussini on 27/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import XCTest
@testable import Mazes

class MazesUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        app.launchArguments = [ "uitest-environment" ]
        app.launch()
        continueAfterFailure = false
        super.setUp()
    }
    override func tearDown() {
        app = nil
        super.tearDown()
    }

    func testMazeTypeSegmentedControl() throws {
        let mazeTypeSegmentedControl = app.segmentedControls["MazeTypeSegmentedControlIdentifier"]
        let binaryTreeSegment = mazeTypeSegmentedControl.buttons.element(boundBy: 0)
        let sidewinderSegment = mazeTypeSegmentedControl.buttons.element(boundBy: 1)

        XCTAssertTrue(binaryTreeSegment.exists)
        XCTAssertTrue(sidewinderSegment.exists)
        XCTAssertEqual(binaryTreeSegment.label, "Binary tree")
        XCTAssertEqual(sidewinderSegment.label, "Sidewinder")
        XCTAssertTrue(binaryTreeSegment.isSelected)
        XCTAssertFalse(sidewinderSegment.isSelected)

        sidewinderSegment.tap()

        XCTAssertFalse(binaryTreeSegment.isSelected)
        XCTAssertTrue(sidewinderSegment.isSelected)
    }

}
