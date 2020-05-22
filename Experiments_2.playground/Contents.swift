import UIKit

public typealias LinkableSet = Set<AnyHashable>

public class PositionableStorage<Position: Positioning, Item: Linkable> {
    fileprivate var neighbors = LinkableSet()
    fileprivate var neighborsLayout = [Position: Item]()
}

public protocol Positionable {
    associatedtype Position: Positioning
    associatedtype Item: Linkable
    var positionableStorage: PositionableStorage<Position, Item> { get }

    func set(position: Position, item: Item)
    @discardableResult func remove(item at: Position) -> Item?
    func get(position: Position) -> Item?
}

extension Positionable {
    public func set(position: Position, item: Item) {
        positionableStorage.neighborsLayout[position] = item
        positionableStorage.neighbors.insert(item)
    }

    @discardableResult public func remove(item at: Position) -> Item? {
        guard let itemAt = get(position: at) else { return nil }

        positionableStorage.neighborsLayout.removeValue(forKey: at)
        positionableStorage.neighbors.remove(itemAt)

        return itemAt
    }
//    public func remove(item: Item) {
//        var neighborsLayout = positionableStorage.neighborsLayout
//        let element = neighborsLayout.first { (arg0) -> Bool in
//            let (_, value) = arg0
//            return value == item
//        }
//        if let coordinate = element?.key {
//            neighborsLayout.removeValue(forKey: coordinate)
//        }
//        positionableStorage.neighbors.remove(item)
//    }

    public func get(position: Position) -> Item? {
        return positionableStorage.neighborsLayout[position]
    }
}

public protocol Positioning: Hashable { }

public enum Coordinates2D: Positioning {
    case north
    case south
    case east
    case west
}

//enum Coordinates2D: Positioning {
//    case north(cell: Cell)
//    case south(cell: Cell)
//    case east(cell: Cell)
//    case west(cell: Cell)
//
//    public var cell: Cell {
//        switch self {
//        case .north(let cell):
//            return cell
//        case .south(let cell):
//            return cell
//        case .east(let cell):
//            return cell
//        case .west(let cell):
//            return cell
//        }
//    }
//}

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
    public func link(to: Self, bidirectional: Bool = true) {
        linkableStorage.linked.insert(to)
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

//public protocol Linkable: Hashable {
//    associatedtype Item: Linkable
//    var storage: LinkableStorage { get }
//
//    func link<L: Linkable>(to: L, bidirectional: Bool)
//    func unlink<L: Linkable>(from: L, bidirectional: Bool)
//    func isLinkedTo<L: Linkable>(_ item: L?) -> Bool
//}

//extension Linkable {
//    public func link<L: Linkable>(to: L, bidirectional: Bool = true) {
//        storage.linked.insert(to)
//        if bidirectional {
//            to.link(to: self, bidirectional: false)
//        }
//    }
//
//    public func unlink<L: Linkable>(from: L, bidirectional: Bool = true) {
//        storage.linked.remove(from)
//        if bidirectional {
//            from.unlink(from: self, bidirectional: false)
//        }
//    }
//
//    public func isLinkedTo<L: Linkable>(_ item: L?) -> Bool {
//        guard let item = item else { return false }
//
//        return storage.linked.contains(item)
//    }
//}

typealias Connectable = Linkable & Positionable

public struct Cell: Connectable {
    public typealias Position = Coordinates2D
    public typealias Item = Cell

    public let linkableStorage = LinkableStorage()
    public let positionableStorage = PositionableStorage<Coordinates2D, Cell>()

    let row: Int
    let column: Int

    init(_ row: Int, _ column: Int) {
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

    func printLinked() {
        print("Linked: ")
        for cell in linkableStorage.linked {
            print(cell)
        }
    }
}

extension Cell: CustomStringConvertible {
    public var description: String {
        return "(row: \(row), column: \(column))"
    }
}

var cell0_0 = Cell(0, 0)
var cell0_1 = Cell(0, 1)
var cell0_2 = Cell(0, 2)

let cell1_1 = Cell(1, 1)

cell0_1.link(to: cell1_1)
cell0_1.printLinked()
cell1_1.printLinked()

cell0_1.link(to: cell0_2) //, bidirectional: false)
cell0_1.printLinked()
print(cell1_1.linkableStorage.linked.count)
let cell0_1_from1_1_linked = cell1_1.linkableStorage.linked.first as! Cell
cell0_1_from1_1_linked.printLinked()
cell0_1.linkableStorage.linked.insert("")

cell0_1.set(position: .south, item: cell1_1)
cell0_1.get(position: .north)
cell0_1.get(position: .south)
cell0_1.remove(item: .south)
cell0_1.get(position: .south)
//public protocol Linkable {
//    var storage: Set<AnyHashable> { get }
//    mutating func link(to: AnyHashable, bidirectional: Bool)
//    mutating func unlink(from: AnyHashable, bidirectional: Bool)
//    func isLinkedTo(_ item: AnyHashable?) -> Bool
//}

//extension Linkable {
//    mutating public func link(to: AnyHashable, bidirectional: Bool = true) {
//        internalLinked.insert(to)
//    }
//
//    mutating public func unlink(from: AnyHashable, bidirectional: Bool = true) {
//        internalLinked.remove(from)
//    }
//
//    public func isLinkedTo(_ item: AnyHashable?) -> Bool {
//        guard let item = item else { return false }
//        return internalLinked.contains(item)
//    }
//}

/**
public class LinkableCell: Linkable {
    public private(set) var storage: Set<AnyHashable> = []

    public func link(to: AnyHashable, bidirectional: Bool = true) {
        storage.insert(to)
    }

    public func unlink(from: AnyHashable, bidirectional: Bool = true) {
        storage.remove(from)
    }

    public func isLinkedTo(_ item: AnyHashable?) -> Bool {
        guard let item = item else { return false }
        return storage.contains(item)
    }
}

public class Cell: LinkableCell, Hashable {
    let row: Int
    let column: Int

    init(_ row: Int, _ column: Int) {
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

var cell0_0 = Cell(0, 0)
let cell0_1 = Cell(0, 1)
cell0_0.link(to: cell0_1)
//cell0_0.storage = [] // Not possible
*/

//private protocol LinkableInternals {
//    var internalLinked: Set<AnyHashable> { set get }
//}

//public struct LinkableCell: Linkable {
//    private var internalLinked = Set<AnyHashable>()
//    private var internalNeighbours = Set<AnyHashable>()
//
//    public var linked: Set<AnyHashable> {
//        get {
//            return internalLinked
//        }
//    }
//
//    public var neighbours: Set<AnyHashable> {
//        get {
//            return internalNeighbours
//        }
//    }
//
//    mutating public func link(to: AnyHashable, bidirectional: Bool = true) {
//        internalLinked.insert(to)
//    }
//
//    mutating public func unlink(from: AnyHashable, bidirectional: Bool = true) {
//        internalLinked.remove(from)
//    }
//
//    public func isLinkedTo(_ item: AnyHashable?) -> Bool {
//        guard let item = item else { return false }
//        return internalLinked.contains(item)
//    }
//}

/**
public class LinkableCell: Linkable {
    private let concreteLinkable: Linkable

    public var linked: Set<AnyHashable> {
        get {
            concreteLinkable.linked
        }
    }

    public var neighbours: Set<AnyHashable> {
        get {
            concreteLinkable.neighbours
        }
    }

    public func link(to: AnyHashable, bidirectional: Bool) {

    }

    public func unlink(from: AnyHashable, bidirectional: Bool) {

    }

    public func isLinkedTo(_ item: AnyHashable?) -> Bool {
        return false
    }

    init(concreteLinkable: Linkable) {
        self.concreteLinkable = concreteLinkable
    }
}

public class Cell: LinkableCell, Hashable {
    public static func == (lhs: Cell, rhs: Cell) -> Bool {
        return lhs.row == rhs.row &&
               lhs.column == rhs.column
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }

    let row: Int
    let column: Int

    init(_ row: Int, _ column: Int) {
        self.row = row
        self.column = column
    }
}

let cell = Cell(0, 0)
LinkableCell(concreteLinkable: cell)
*/



//public struct Cell: LinkableCell {
//    let row: Int
//    let column: Int
//
//    init(_ row: Int, _ column: Int) {
//        self.row = row
//        self.column = column
//        super.init(delegate: self)
//
//    }
//
//    public static func == (lhs: Cell, rhs: Cell) -> Bool {
//        return lhs.row == rhs.row &&
//               lhs.column == rhs.column
//    }
//
//    public override func hash(into hasher: inout Hasher) {
//        hasher.combine(row)
//        hasher.combine(column)
//    }
//}

//var cell = LinkableCell(0, 2)
//let cell2 = LinkableCell(0, 2)
//cell.link(to: cell2)
//print(cell.linked)
//cell == cell2

//var dict = [String: LinkableCell]()
//dict["1"] = cell
//dict["1"] == cell
//cell.pippo = 1
//dict["1"] == cell

struct AnyEquatable {
    private let isEqualTo: (Any) -> Bool
    let value: Any

    init<A: Equatable>(_ value: A) {
        self.value = value
        isEqualTo = { other in
            guard let o = other as? A else { return false }
            return value == o
        }
    }
}

extension AnyEquatable: Equatable {
    static func ==(lhs: AnyEquatable, rhs: AnyEquatable) -> Bool {
        return lhs.isEqualTo(rhs.value)
    }
}

let ss = UIView()
let x = AnyEquatable(ss)
let x1 = AnyEquatable(ss)
let y = AnyEquatable("hello")
x == y
x == x1

AnyEquatable(4) == AnyEquatable(4)

AnyHashable("ciao").hashValue
AnyHashable("ciau").hashValue
