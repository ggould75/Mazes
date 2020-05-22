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
    mutating func set<L: Linkable>(position: Coordinate, item: L) {
        guard let item = item as? Self.Item else {
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

public protocol MySet {
    associatedtype Item
    func insert(_ item: Item)
    func remove(_ item: Item)
    func contains(_ item: Item?) -> Bool
}

class Test: MySet {
    func insert(_ item: String) {

    }

    func remove(_ item: String) {

    }

    func contains(_ item: String?) -> Bool {
        return true
    }
}

var cell0_2 = Cell(0, 2)
var cell1_2 = Cell(1, 2)
cell1_2.set(position: .north, item: cell0_2)
print(cell1_2.neighbours)
print(cell1_2.mapping)

cell1_2.get(position: .north)
cell1_2.get(position: .south)

cell1_2.link(toCell: &cell0_2, bidirectional: true)
print(cell1_2.linked)
print(cell0_2.linked)

/**
typealias Connectable = Linkable & Positionable

protocol Linkable: Hashable {
    associatedtype Item: Connectable
    var neighbouringCells: Set<Item> { get set }
    var linkedCells: Set<Item> { get set }
}

extension Linkable {
    mutating func link<T: Linkable>(toCell: inout T, bidirectional: Bool) {
        guard var toItem = toCell as? Item else { return }

        linkedCells.insert(toItem)
        if bidirectional {
            toItem.link(toCell: &self, bidirectional: false)
        }
    }

    mutating func unlink<T: Linkable>(fromCell: inout T, bidirectional: Bool) {
        guard var fromItem = fromCell as? Item else { return }

        linkedCells.remove(fromItem)
        if bidirectional {
            fromItem.unlink(fromCell: &self, bidirectional: false)
        }
    }

    func isLinkedTo<I: Linkable>(cell: I?) -> Bool {
        guard let item = cell as? Item else { return false }

        return linkedCells.contains(item)
    }
}

class Cell: Connectable {
    typealias Item = Cell

    func set<C, L>(position: C, item: L) where C : Coordinate, L : Linkable {

    }

    static func == (lhs: Cell, rhs: Cell) -> Bool {
        return true
    }

    func hash(into hasher: inout Hasher) {

    }
}
*/
