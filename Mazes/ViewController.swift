//
//  ViewController.swift
//  Mazes
//
//  Created by Marco Mussini on 26/10/2017.
//  Copyright © 2017 Marco Mussini. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var shouldIgnoreUserDefaults = false
    var userDefaults = UserDefaults.standard

    enum MazeType: Int, RawRepresentable, CaseIterable, Equatable {
        case binaryTree
        case sidewinder
    }
    var mazeType = MazeType.binaryTree

    lazy var mazeTypeSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Binary tree", "Sidewinder"])
        control.accessibilityIdentifier = "MazeTypeSegmentedControlIdentifier"
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        let defaultAttributes = [ NSAttributedString.Key.foregroundColor: UIColor.red ]
        control.setTitleTextAttributes(defaultAttributes, for: .normal)
        control.addTarget(self, action: #selector(didChangeMazeType(_:)), for: .valueChanged)

        return control
    }()

    lazy var mazeView: MazeView = {
        let mazeView = MazeView(maze: randomMaze())
        mazeView.translatesAutoresizingMaskIntoConstraints = false
        mazeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMaze)))

        return mazeView
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }

    init(shouldIgnoreUserDefaults: Bool = false) {
        self.shouldIgnoreUserDefaults = shouldIgnoreUserDefaults
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mazeTypeSegmentedControl)
        view.addSubview(mazeView)

        NSLayoutConstraint.activate([
            mazeTypeSegmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mazeTypeSegmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mazeTypeSegmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            mazeView.topAnchor.constraint(equalTo: mazeTypeSegmentedControl.bottomAnchor),
            mazeView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mazeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mazeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        let initialMazeType = userDefaults.integer(forKey: "mazeType")
        if !shouldIgnoreUserDefaults, initialMazeType >= 0, initialMazeType < MazeType.allCases.count {
            mazeTypeSegmentedControl.selectedSegmentIndex = initialMazeType
            mazeType = MazeType(rawValue: initialMazeType) ?? .binaryTree
        } else {
            userDefaults.set(0, forKey: "mazeType")
            mazeType = MazeType(rawValue: 0) ?? .binaryTree
        }
        updateMazeView()
    }

    @objc func didChangeMazeType(_ sender: UISegmentedControl) {
        let segmentIndex = sender.selectedSegmentIndex
        mazeType = MazeType(rawValue: segmentIndex) ?? .binaryTree
        userDefaults.set(segmentIndex, forKey: "mazeType")
        updateMazeView()
    }

    @objc func didTapMaze() {
        updateMazeView()
    }

    private func randomMaze() -> Grid {
        let maze = Grid(rows: 60, columns: 33)
        switch mazeType {
        case .binaryTree:
            maze.buildBinaryTreeMaze()
        case .sidewinder:
            maze.buildSidewinderMaze()
        }

        return maze
    }

    private func updateMazeView() {
        mazeView.maze = randomMaze()
    }
}

