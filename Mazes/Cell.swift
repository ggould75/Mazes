//
//  Cell.swift
//  Mazes
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import Foundation

enum Coordinate {
    case north, south, east, west
}

protocol Linkable: Hashable {
    associatedtype Item: Linkable
    var linked: Set<Item> { get set }
}

extension Linkable {
    mutating func link<T: Linkable>(toCell: inout T, bidirectional: Bool) {
        guard var toItem = toCell as? Item else { return }

        linked.insert(toItem)
        if bidirectional {
            toItem.link(toCell: &self, bidirectional: false)
        }
    }

    mutating func unlink<T: Linkable>(fromCell: inout T, bidirectional: Bool) {
        guard var fromItem = fromCell as? Item else { return }

        linked.remove(fromItem)
        if bidirectional {
            fromItem.unlink(fromCell: &self, bidirectional: false)
        }
    }

    func isLinkedTo<I: Linkable>(cell: I?) -> Bool {
        guard let item = cell as? Item else { return false }

        return linked.contains(item)
    }
}

protocol Positionable {
    associatedtype Item: Linkable
    var mapping: [Coordinate: Item] { get set }
    var neighbours: Set<Item> { get set }

//    func set<L: Linkable>(position: Coordinate, item: L)
//    func remove<L: Linkable>(item: L)
//    func get(position: Coordinate) -> Item?
}

extension Positionable {
    mutating func set<L: Linkable>(position: Coordinate, item: L?) {
        guard let item = item as? Self.Item else {
            if let itemAtPosition = mapping[position] {
                neighbours.remove(itemAtPosition)
            }
            mapping[position] = nil
            return
        }
        
        mapping[position] = item
        neighbours.insert(item)
    }

    mutating func remove<L: Linkable>(item: L) {
        guard let item = item as? Self.Item else {
            return
        }
        let element = mapping.first { (arg0) -> Bool in
            let (_, value) = arg0
            return value == item
        }
        if let coordinate = element?.key {
            mapping.removeValue(forKey: coordinate)
        }
        neighbours.remove(item)
    }

    func get(position: Coordinate) -> Item? {
        return mapping[position]
    }
}

typealias Connectable = Linkable & Positionable

class Cell: Connectable {
    typealias Item = Cell

    var linked = Set<Cell>()
    var mapping = [Coordinate : Cell]()
    var neighbours = Set<Cell>()

    var row: Int
    var column: Int

    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }

    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.row == rhs.row &&
               lhs.column == rhs.column
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }
}

extension Cell: CustomStringConvertible {
    var description: String {
        return "(row: \(row), column: \(column))"
    }
}

extension Cell {
    // Time: O(V + E) ??
    func dijkstra() -> Distances {
        var distances = Distances(root: self)
        var frontierCells = [self]

        while !frontierCells.isEmpty {
            var newFrontierCells = [Cell]()
            for cell in frontierCells {
                for linkedCell in cell.linked {
                    guard distances[linkedCell] == nil else { continue }

                    distances[linkedCell] = (distances[cell] ?? 0) + 1
                    newFrontierCells.append(linkedCell)
                }
            }

            frontierCells = newFrontierCells
        }

        return distances
    }
}

extension Cell {
    func topWallAsAscii() -> String {
        guard let northCell = get(position: .north), isLinkedTo(cell: northCell) else {
            return "+---"
        }

        return "+   "
    }

    func bodyAsAscii() -> String {
        guard let westCell = get(position: .west), isLinkedTo(cell: westCell) else {
            return "|   "
        }

        return "    "
    }

    func bottomWallAsAscii() -> String {
        guard let southCell = get(position: .south), isLinkedTo(cell: southCell) else {
            return "+---"
        }

        return "+   "
    }
}
