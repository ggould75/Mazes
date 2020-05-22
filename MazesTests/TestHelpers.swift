//
//  TestHelpers.swift
//  MazesTests
//
//  Created by Marco Mussini on 21/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import Foundation
@testable import Mazes

struct LinkableFixture: Linkable {
    let linkableStorage = LinkableStorage()
    var identifier = ""

    static func == (lhs: LinkableFixture, rhs: LinkableFixture) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    public func hash(into hasher: inout Hasher) { }
}
