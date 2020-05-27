//
//  MazeView.swift
//  Mazes
//
//  Created by Marco Mussini on 25/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import UIKit

class MazeView: UIView {
    var maze: Grid {
        didSet {
            setNeedsDisplay()
        }
    }

    init(maze: Grid) {
        self.maze = maze
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(1.0)

        context?.clear(rect)

        let viewSize = bounds.size
        let cellSize = CGSize(width: viewSize.width / CGFloat(maze.numberOfColumns),
                              height: viewSize.height / CGFloat(maze.numberOfRows))
        let cellWidth = cellSize.width
        let cellHeight = cellSize.height

        for rowCells in maze.cells {
            for cell in rowCells {
                let x1 = CGFloat(cell.column) * cellWidth
                let y1 = CGFloat(cell.row) * cellHeight
                let x2 = CGFloat(cell.column + 1) * cellWidth
                let y2 = CGFloat(cell.row + 1) * cellHeight

                if cell.get(.north) == nil {
                    context?.move(to: CGPoint(x: x1, y: y1))
                    context?.addLine(to: CGPoint(x: x2, y: y1))
                }
                if cell.get(.west) == nil {
                    context?.move(to: CGPoint(x: x1, y: y1))
                    context?.addLine(to: CGPoint(x: x1, y: y2))
                }
                if !cell.isLinkedTo(cell.get(.east)) {
                    context?.move(to: CGPoint(x: x2, y: y1))
                    context?.addLine(to: CGPoint(x: x2, y: y2))
                }
                if !cell.isLinkedTo(cell.get(.south)) {
                    context?.move(to: CGPoint(x: x1, y: y2))
                    context?.addLine(to: CGPoint(x: x2, y: y2))
                }
            }
        }

        context?.strokePath()
    }
}
