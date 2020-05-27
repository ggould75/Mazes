//
//  ViewControllerTests.swift
//  MazesTests
//
//  Created by Marco Mussini on 27/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import XCTest
@testable import Mazes

class ViewControllerTests: XCTestCase {

    var sut: ViewController!
    var mockUserDefaults: MockUserDefaults!

    override func setUp() {
        super.setUp()
        sut = ViewController()
        mockUserDefaults = MockUserDefaults(suiteName: "testing")
        sut.userDefaults = mockUserDefaults
    }

    override func tearDown() {
        sut = nil
        mockUserDefaults = nil
        super.tearDown()
    }

    func testMazeTypeIsSwitched() {
        let segmentedControl = UISegmentedControl()

        XCTAssertEqual(sut.mazeType, ViewController.MazeType.binaryTree)

        segmentedControl.addTarget(sut, action: #selector(ViewController.didChangeMazeType(_:)), for: .valueChanged)
        segmentedControl.sendActions(for: .valueChanged)

        XCTAssertEqual(mockUserDefaults.mazeTypeChanged, 1)
    }

}

class MockUserDefaults: UserDefaults {
    var mazeTypeChanged = 0
    override func set(_ value: Int, forKey defaultName: String) {
        if defaultName == "mazeType" {
            mazeTypeChanged += 1
        }
    }
}
