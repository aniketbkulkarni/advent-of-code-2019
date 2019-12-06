import Foundation

struct Node {
  let name: String
  var parent: String?

  init(name: String, parent: String? = nil) {
    self.name = name
    self.parent = parent
  }
}

// Part 1
// Create "reverse" adjacency list, child -> parent
func getOrbits(_ edges: [[String]]) -> [String: Node] {
  var orbits = [String: Node]()

  for edge in edges {
    let parentName = edge[0]
    let childName = edge[1]

    // Create parent node if it doesn't exist
    if orbits[parentName] == nil {
      orbits[parentName] = Node(name: parentName)
    }

    orbits[childName] = Node(name: childName, parent: parentName)
  }

  return orbits
}

// Find # of parents for all nodes, then sum all 
func calculateChecksum(_ orbits: [String: Node]) -> Int {
  var checkSum = 0

  // Avoid duplicate work for nodes we have previously visited
  var memo = [String: Int]()

  for (name, node) in orbits {
    var parentCount = 0

    // Get initial parent node or nonexistant node
    var parent = orbits[node.parent ?? ""]

    // While we can keep moving up the chain, set parent=grandparent and increment count
    while parent != nil {
      if let memoCount = memo[parent!.name] {
        parentCount += (memoCount+1)
        break
      } else {
        parentCount += 1
      }

      // Get next parent node or nonexistant node
      parent = orbits[parent?.parent ?? ""]
    }

    memo[name] = parentCount
    checkSum += parentCount
  }

  return checkSum
}

// Part 2
func calculateTransfers(_ orbits: [String: Node]) -> Int {
  // Get the two nodes Santa and I are orbitting
  guard let youNode = orbits["YOU"], let santaNode = orbits["SAN"] else { fatalError() }

  let youParents = getParents(for: youNode, orbits)
  let santaParents = getParents(for: santaNode, orbits)

  // Contains just the nodes required for doing orbital transfer
  return youParents.symmetricDifference(santaParents).count
}

func getParents(for node: Node, _ orbits: [String: Node]) -> Set<String> {
  var parents = Set<String>()

  // Get initial parent node or nonexistant node
  var parent = orbits[node.parent ?? ""]

  while parent != nil {
    parents.insert(parent!.name)

    // Get next parent node or nonexistant node
    parent = orbits[parent?.parent ?? ""]
  }

  return parents
}

///
// "D5Q)KRQ..." -> [["D5Q", "KRQ"]...]
let formatter: (String) -> ([[String]]) = { input in
  return input
    .split(separator: "\n")
    .map { String($0) }
    .map { $0.split(separator: ")") }
    .map { [String($0[0]), String($0[1])] }
}

let testURL = Bundle.main.url(forResource: "test", withExtension: "txt")
let testRaw = try String(contentsOf: testURL!, encoding: String.Encoding.utf8)
let testEdges = formatter(testRaw)
testEdges.count

let test2URL = Bundle.main.url(forResource: "test2", withExtension: "txt")
let test2Raw = try String(contentsOf: test2URL!, encoding: String.Encoding.utf8)
let test2Edges = formatter(test2Raw)
test2Edges.count

let puzzleURL = Bundle.main.url(forResource: "puzzle", withExtension: "txt")
let puzzleRaw = try String(contentsOf: puzzleURL!, encoding: String.Encoding.utf8)
let puzzleEdges = formatter(puzzleRaw)
puzzleEdges.count

calculateChecksum(getOrbits(testEdges))
calculateChecksum(getOrbits(puzzleEdges))

calculateTransfers(getOrbits(test2Edges))
calculateTransfers(getOrbits(puzzleEdges))
