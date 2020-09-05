//Task 1
class LinkedList {
    var key: String?
    
    var firstItem: LinkedList?
    var next: LinkedList?
    var previous: LinkedList?
    
    init(value: String?) {
        self.key = value
    }
    
    convenience init(values: [String]) {
        self.init(value: values.first)
        var node = self
        let firstItem = node
        
        for i in 1..<values.count {
            let next = LinkedList(value: values[i])
            let previous = LinkedList(value: values[i-1])
            
            next.previous = previous
            
            node.next = next
            node.firstItem = firstItem
            node = next as! Self
        }
    }
    
    func find(of line: String) -> LinkedList? {
        var node = firstItem
        
        while node != nil {
            if node!.key == line {
                return node
            }
            node = node!.next
        }
        
        return nil
    }
}

let list = LinkedList(values: ["qw", "er", "ty", "zx"])
list.next?.find(of: "zx")?.key

//Task 2
class TreeNode {
    var value: String
    
    var left: TreeNode?
    var right: TreeNode?
    
    init(value: String) {
        self.value = value
    }
}

class BinaryTree {
    private var rootNode: TreeNode?
    
    func insert(value: String) {
        let node = TreeNode(value: value)
        if let rootNode = self.rootNode {
            insert(rootNode, node)
        } else {
            self.rootNode = node
        }
    }
    
    func insert(_ rootNode: TreeNode, _ node: TreeNode) {
        if rootNode.value > node.value {
            if let leftNode = rootNode.left {
                insert(leftNode, node)
            } else {
                rootNode.left = node
            }
        } else {
            if let rightNode = rootNode.right {
                insert(rightNode, node)
            } else {
                rootNode.right = node
            }
        }
    }
    
    func search(value: String) -> TreeNode? {
        return search(self.rootNode, value)
    }
    
    private func search(_ rootNode: TreeNode?, _ value: String) -> TreeNode? {
        guard let rootNode = rootNode else { return nil }
        
        if value > rootNode.value {
            return search(rootNode.right, value)
        } else if value < rootNode.value {
            return search(rootNode.left, value)
        } else {
            return rootNode
        }
    }
}

let tree = BinaryTree()

tree.insert(value: "Z")
tree.insert(value: "B")
tree.insert(value: "F")
tree.insert(value: "G")
tree.insert(value: "H")
tree.insert(value: "D")
tree.insert(value: "X")
tree.insert(value: "A")

let searchNode = tree.search(value: "D")
searchNode?.value

//Task 3
struct Stack<T> {
    var array: [T] = []
    
    mutating func push(_ element: T) {
        array.append(element)
    }
    
    mutating func pop() -> T? {
        return array.popLast()
    }
    
    func peek() -> T? {
        return array.last
    }
}

extension Stack: CustomStringConvertible {
    var description: String {
        let topDivider = "---Stack---\n"
        let bottomDivider = "\n-----------\n"
        
        var result = ""
        
        for i in 0..<array.count {
            result.append("\(array[i])\n")
        }
        
        return topDivider + result + bottomDivider
    }
}

public struct Vertex<T: Hashable> {
    var data: T
}

extension Vertex: Hashable {
    public var hashValue: Int {
        return "\(data)".hashValue
    }
    
    static public func ==(lhs: Vertex, rhs: Vertex) -> Bool {
        return lhs.data == rhs.data
    }
}

extension Vertex: CustomStringConvertible {
    public var description: String {
        return "\(data)"
    }
}

public enum EdgeType {
    case directed, undirected
}

public struct Edge<T: Hashable> {
    public var source: Vertex<T>
    public var destination: Vertex<T>
    public let weight: Double?
}

extension Edge: Hashable {
    public var hashValue: Int {
        return "\(source)\(destination)\(weight)".hashValue
    }
    
    static public func ==(lhs: Edge<T>, rhs: Edge<T>) -> Bool {
        return lhs.source == rhs.source &&
            lhs.destination == rhs.destination &&
            lhs.weight == rhs.weight
    }
}

protocol Graphable {
    associatedtype Element: Hashable
    var description: CustomStringConvertible { get }
    
    func createVertex(data: Element) -> Vertex<Element>
    func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?)
    func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double?
    func edges(from source: Vertex<Element>) -> [Edge<Element>]?
}

class AdjacencyList<T: Hashable> {
    public var adjacencyDict : [Vertex<T>: [Edge<T>]] = [:]
    public init() {}
}

extension AdjacencyList: Graphable {
    public typealias Element = T
    
    public var description: CustomStringConvertible {
        var result = ""
        for (vertex, edges) in adjacencyDict {
            var edgeString = ""
            for (index, edge) in edges.enumerated() {
                if index != edges.count - 1 {
                    edgeString.append("\(edge.destination), ")
                } else {
                    edgeString.append("\(edge.destination)")
                }
            }
            result.append("\(vertex) ---> [ \(edgeString) ] \n ")
        }
        return result
    }
    
    public func createVertex(data: Element) -> Vertex<Element> {
        let vertex = Vertex(data: data)
        
        if adjacencyDict[vertex] == nil {
            adjacencyDict[vertex] = []
        }
        
        return vertex
    }
    
    public func add(_ type: EdgeType, from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        switch type {
        case .directed:
            addDirectedEdge(from: source, to: destination, weight: weight)
        case .undirected:
            addUndirectedEdge(vertices: (source, destination), weight: weight)
        }
    }
    
    public func weight(from source: Vertex<Element>, to destination: Vertex<Element>) -> Double? {
        guard let edges = adjacencyDict[source] else {
            return nil
        }
        
        for edge in edges {
            if edge.destination == destination {
                return edge.weight
            }
        }
        
        return nil
    }
    
    public func edges(from source: Vertex<Element>) -> [Edge<Element>]? {
        return adjacencyDict[source]
    }
    
    private func addDirectedEdge(from source: Vertex<Element>, to destination: Vertex<Element>, weight: Double?) {
        let edge = Edge(source: source, destination: destination, weight: weight)
        adjacencyDict[source]?.append(edge)
    }
    
    private func addUndirectedEdge(vertices: (Vertex<Element>, Vertex<Element>), weight: Double?) {
        let (source, destination) = vertices
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
}

let adjacencyList = AdjacencyList<String>()

let singapore = adjacencyList.createVertex(data: "Singapore")
let tokyo = adjacencyList.createVertex(data: "Tokyo")
let hongKong = adjacencyList.createVertex(data: "Hong Kong")
let detroit = adjacencyList.createVertex(data: "Detroit")
let sanFrancisco = adjacencyList.createVertex(data: "San Francisco")
let washingtonDC = adjacencyList.createVertex(data: "Washington DC")
let austinTexas = adjacencyList.createVertex(data: "Austin Texas")
let seattle = adjacencyList.createVertex(data: "Seattle")

adjacencyList.add(.undirected, from: singapore, to: hongKong, weight: 300)
adjacencyList.add(.undirected, from: singapore, to: tokyo, weight: 500)
adjacencyList.add(.undirected, from: hongKong, to: tokyo, weight: 250)
adjacencyList.add(.undirected, from: tokyo, to: detroit, weight: 450)
adjacencyList.add(.undirected, from: tokyo, to: washingtonDC, weight: 300)
adjacencyList.add(.undirected, from: hongKong, to: sanFrancisco, weight: 600)
adjacencyList.add(.undirected, from: detroit, to: austinTexas, weight: 50)
adjacencyList.add(.undirected, from: austinTexas, to: washingtonDC, weight: 292)
adjacencyList.add(.undirected, from: sanFrancisco, to: washingtonDC, weight: 337)
adjacencyList.add(.undirected, from: washingtonDC, to: seattle, weight: 277)
adjacencyList.add(.undirected, from: sanFrancisco, to: seattle, weight: 218)
adjacencyList.add(.undirected, from: austinTexas, to: sanFrancisco, weight: 297)

print(adjacencyList.description)

func depthFirstSearch(from start: Vertex<String>, to end: Vertex<String>, graph: AdjacencyList<String>) -> Stack<Vertex<String>> {
    var visited = Set<Vertex<String>>()
    var stack = Stack<Vertex<String>>()
    
    stack.push(start)
    visited.insert(start)
    
    outer: while let vertex = stack.peek(), vertex != end {
        guard let neighbors = graph.edges(from: vertex), neighbors.count > 0 else {
            print("backtrack from \(vertex)")
            stack.pop()
            continue
        }
        
        for edge in neighbors {
            if !visited.contains(edge.destination) {
                visited.insert(edge.destination)
                stack.push(edge.destination)
                print(stack.description)
                continue outer
            }
        }
        
        print("backtrack from \(vertex)")
        stack.pop()
    }
    
    return stack
}

depthFirstSearch(from: hongKong, to: sanFrancisco, graph: adjacencyList)

//Task 4
extension Array where Element: Comparable {
    
    func insertionSort() -> Array<Element> {
        guard self.count > 1 else { return self }
        
        var output: Array<Element> = self
        
        for primaryindex in 0..<output.count {
            let key = output[primaryindex]
            var secondaryindex = primaryindex
            
            while secondaryindex > -1 {
                if key < output[secondaryindex] {
                    output.remove(at: secondaryindex + 1)
                    output.insert(key, at: secondaryindex)
                }
                
                secondaryindex -= 1
            }
        }
        
        return output
    }
    
    func selectionSort() -> Array<Element> {
        guard self.count > 1 else { return self }
        
        var output: Array<Element> = self
        
        for primaryindex in 0..<output.count {
            var minimum = primaryindex
            var secondaryindex = primaryindex + 1
            
            while secondaryindex < output.count {
                if output[minimum] > output[secondaryindex] {
                    minimum = secondaryindex
                }
                secondaryindex += 1
            }
            
            if primaryindex != minimum {
                output.swapAt(primaryindex, minimum)
            }
        }
        
        return output
    }
}

[0, 1, 2, 10, 22, -12, 4, 6].insertionSort()
[0, 1, 2, 10, 22, -12, 4, 6].selectionSort()
