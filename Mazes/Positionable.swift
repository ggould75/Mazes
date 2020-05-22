//
//  Positionable.swift
//  Mazes
//
//  Created by Marco Mussini on 21/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import Foundation

public class PositionableStorage<Position: Positioning, Item: Linkable> {
    fileprivate var neighbors = LinkableSet()
    fileprivate var neighborsLayout = [Position: Item]()
}

public protocol Positionable {
    associatedtype Position: Positioning
    associatedtype Item: Linkable
    var positionableStorage: PositionableStorage<Position, Item> { get }

    func set(item: Item?, at position: Position)
    func get(_ at: Position) -> Item?
    @discardableResult func remove(item at: Position) -> Item?
}

extension Positionable {
    public var neighbors: LinkableSet {
        return positionableStorage.neighbors
    }

    // TODO: check if I should use updateValue(_:forKey:)
    public func set(item: Item?, at position: Position) {
        guard let item = item else {
            remove(item: position)
            return
        }

        if neighbors.contains(item) {
            let element = positionableStorage.neighborsLayout.first { (arg0) -> Bool in
                let (_, value) = arg0
                return value == item
            }
            if let position = element?.key {
                positionableStorage.neighborsLayout.removeValue(forKey: position)
            }
        }

        positionableStorage.neighborsLayout[position] = item
        _ = positionableStorage.neighbors.insert(item)
    }

    public func get(_ at: Position) -> Item? {
        return positionableStorage.neighborsLayout[at]
    }

    @discardableResult public func remove(item at: Position) -> Item? {
        guard let itemAt = get(at) else { return nil }

        positionableStorage.neighborsLayout.removeValue(forKey: at)
        positionableStorage.neighbors.remove(itemAt)

        return itemAt
    }
}

public protocol Positioning: Hashable { }
