//
//  MazeBuilders.swift
//  Mazes
//
//  Created by Marco Mussini on 22/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import Foundation

extension Grid {

    // Time: O(r*c) = O(V)
    func buildBinaryTreeMaze() {
        for rowCells in cells {
            for cell in rowCells {
                var neighbors = [Cell]()
                if let northCell = cell.get(.north) {
                    neighbors.append(northCell)
                }
                if let eastCell = cell.get(.east) {
                    neighbors.append(eastCell)
                }

                if neighbors.count == 0 {
                    continue
                }

                var randomNeighborIndex = 0
                if neighbors.count == 2 {
                    randomNeighborIndex = neighbors.count.randomize()
                }

                let randomNeighbor = neighbors[randomNeighborIndex]
                cell.link(to: randomNeighbor)
            }
        }
    }

    // Time: O(r*c) = O(V)
    func buildSidewinderMaze() {
        for rowCells in cells {
            var run = [Cell]()
            for cell in rowCells {
                run.append(cell)

                let isAtEastBoundary = cell.get(.east) == nil
                let isAtNorthBoundary = cell.get(.north) == nil
                let randomDirection = 2.randomize()
                let shouldCloseOutRun =
                    isAtEastBoundary || (!isAtNorthBoundary && randomDirection == 0)

                if shouldCloseOutRun {
                    let randomRunMemberIndex = run.count.randomize()
                    let runMemberCell = run[randomRunMemberIndex]
                    if let runMemberNorthCell = runMemberCell.get(.north) {
                        runMemberCell.link(to: runMemberNorthCell)
                    }

                    run.removeAll()
                }
                else if let eastCell = cell.get(.east) {
                    cell.link(to: eastCell)
                }
            }
        }
    }
}

extension Int {
    func randomize() -> Int {
        return Int.random(in: 0 ..< self)
    }
}
