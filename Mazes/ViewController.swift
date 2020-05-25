//
//  ViewController.swift
//  Mazes
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mazeTypeSegmentedControl: UISegmentedControl!
    var mazeView: MazeView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mazeTypeSegmentedControl = UISegmentedControl(items: ["Binary tree", "Sidewinder"])
        mazeTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        mazeTypeSegmentedControl.selectedSegmentIndex = 0
        let defaultAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.red ]
        mazeTypeSegmentedControl.setTitleTextAttributes(defaultAttributes, for: .normal)
        mazeTypeSegmentedControl.addTarget(self, action: #selector(didChangeMazeType), for: .valueChanged)
        view.addSubview(mazeTypeSegmentedControl)

        mazeView = MazeView(maze: randomMaze())
        mazeView.translatesAutoresizingMaskIntoConstraints = false
        mazeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(mazeView)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))

        NSLayoutConstraint.activate([
            mazeTypeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mazeTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mazeTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            mazeView.topAnchor.constraint(equalTo: mazeTypeSegmentedControl.bottomAnchor),
            mazeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mazeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mazeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func randomMaze() -> Grid {
        let maze = Grid(rows: 60, columns: 30)
        if mazeTypeSegmentedControl.selectedSegmentIndex == 0 {
            maze.buildBinaryTreeMaze()
        } else {
            maze.buildSidewinderMaze()
        }

        return maze
    }

    @objc func didChangeMazeType() {
        mazeView?.maze = randomMaze()
    }

    @objc func didTap() {
        mazeView?.maze = randomMaze()
    }
}

