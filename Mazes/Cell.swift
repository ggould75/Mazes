//
//  Cell.swift
//  Mazes
//
//  Created by Marco Mussini on 21/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import Foundation

public enum Coordinates: Positioning {
    case north
    case south
    case east
    case west
}

public struct Cell: Connectable {
    public typealias Position = Coordinates
    public typealias Item = Cell

    public let linkableStorage = LinkableStorage()
    public let positionableStorage = PositionableStorage<Coordinates, Cell>()

    let row: UInt
    let column: UInt

    init(_ row: UInt, _ column: UInt) {
        self.row = row
        self.column = column
    }

    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.row == rhs.row &&
               lhs.column == rhs.column
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}

extension Cell: CustomStringConvertible {
    public var description: String {
        return "(row: \(row), column: \(column))"
    }
}
