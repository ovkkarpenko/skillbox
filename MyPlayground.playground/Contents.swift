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
struct Edge {
    var distance: Double
    var vertex: Vertex
}

struct Vertex {
    var station: String
    var edges: [Edge]
    
    mutating func addEdge(_ edge: Edge) {
        edges.append(edge)
    }
}

class Metro {
    var stations: [Vertex] = []
    
    func search(from: Vertex, to: Vertex) -> Double {
        var totalDistance = 0.0
        for station in stations {
            for edge in station.edges {
                totalDistance += edge.distance
                
            }
            totalDistance = 0.0
        }
        return totalDistance
    }
    
    func addStation(_ station: Vertex) {
        stations.append(station)
    }
}

var station1 = Vertex(station: "Station 1", edges: [])
var station2 = Vertex(station: "Station 2", edges: [])
var station3 = Vertex(station: "Station 3", edges: [])

let edge1 = Edge(distance: 5, vertex: station1)
let edge2 = Edge(distance: 15, vertex: station1)

let edge3 = Edge(distance: 1, vertex: station2)
let edge5 = Edge(distance: 6, vertex: station2)

let edge6 = Edge(distance: 2, vertex: station3)
let edge7 = Edge(distance: 1, vertex: station3)

station1.addEdge(edge3)
station1.addEdge(edge6)

station2.addEdge(edge1)
station2.addEdge(edge7)

station3.addEdge(edge2)
station3.addEdge(edge5)

let metro = Metro()

metro.addStation(station1)
metro.addStation(station2)
metro.addStation(station3)

metro.search(from: station1, to: station3)

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
