//
//  Distances.swift
//  Mazes
//
//  Created by Marco Mussini on 16/10/2019.
//  Copyright © 2019 Marco Mussini. All rights reserved.
//

struct Distances {
    let rootCell: Cell
    var distances = [Cell : Int]()

    subscript(cell: Cell) -> Int? {
        get {
            return distances[cell]
        }
        set {
            distances[cell] = newValue
        }
    }

    init(root: Cell) {
        self.rootCell = root
        distances[root] = 0
    }
}
