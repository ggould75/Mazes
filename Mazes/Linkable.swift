//
//  Linkable.swift
//  Mazes
//
//  Created by Marco Mussini on 21/05/2020.
//  Copyright © 2020 Marco Mussini. All rights reserved.
//

import Foundation

public typealias LinkableSet = Set<AnyHashable>

public class LinkableStorage {
    fileprivate var linked = LinkableSet()
}

public protocol Linkable: Hashable {
    var linkableStorage: LinkableStorage { get }

    func link(to: Self, bidirectional: Bool)
    func unlink(from: Self, bidirectional: Bool)
    func isLinkedTo(_ item: Self?) -> Bool
}

extension Linkable {
    public var linked: LinkableSet {
        return linkableStorage.linked
    }

    public func link(to: Self, bidirectional: Bool = true) {
        _ = linkableStorage.linked.insert(to)
        if bidirectional {
            to.link(to: self, bidirectional: false)
        }
    }

    public func unlink(from: Self, bidirectional: Bool = true) {
        linkableStorage.linked.remove(from)
        if bidirectional {
            from.unlink(from: self, bidirectional: false)
        }
    }

    public func isLinkedTo(_ item: Self?) -> Bool {
        guard let item = item else { return false }

        return linkableStorage.linked.contains(item)
    }
}
