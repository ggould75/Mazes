//
//  Dijstkra.swift
//  Mazes
//
//  Created by Marco Mussini on 22/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import Foundation

extension Cell {

    // Time: O(V + E) ??
    func dijkstra() -> Distances<Cell> {
        var distances = Distances(root: self)
        var frontierCells = [self]

        while !frontierCells.isEmpty {
            var newFrontierCells = [Cell]()
            for cell in frontierCells {
                for linkedCell in cell.linked {
                    guard distances[linkedCell as! Cell] == nil else { continue }

                    distances[linkedCell as! Cell] = (distances[cell] ?? 0) + 1
                    newFrontierCells.append(linkedCell as! Cell)
                }
            }

            frontierCells = newFrontierCells
        }

        return distances
    }
}

// Space: O(V)
struct Distances<C: Connectable> {
    let rootCell: C
    var distances = [C: Int]()

    subscript(cell: C) -> Int? {
        get {
            return distances[cell]
        }
        set {
            distances[cell] = newValue
        }
    }

    init(root: C) {
        self.rootCell = root
        distances[root] = 0
    }
}
