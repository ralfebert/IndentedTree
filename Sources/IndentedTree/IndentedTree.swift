import Foundation

public struct TreeNode<T: Equatable>: Equatable {
    var content: T
    var children: [TreeNode] = []
}

public struct IndentedTreeNode<T: Equatable>: Equatable {
    var indent: Int
    var content: T
}

public func flatten<T>(_ node: TreeNode<T>, indent: Int = 0) -> [IndentedTreeNode<T>] {
    [IndentedTreeNode(indent: indent, content: node.content)] + node.children.flatMap { flatten($0, indent: indent + 1) }
}

public func unflatten<T>(_ list: [IndentedTreeNode<T>]) -> TreeNode<T>? {
    guard !list.isEmpty else { return nil }
    var list = list

    var root = TreeNode(content: list.removeFirst().content)
    var lastNodePath = IndexPath(indexes: [0])

    for node in list {
        let pathToNodeParent = lastNodePath.prefix(node.indent - 1)
        root[pathToNodeParent].children.append(TreeNode(content: node.content))
        lastNodePath = pathToNodeParent + [root[pathToNodeParent].children.count - 1]
    }

    return root
}

public extension TreeNode {

    subscript(indexPath: IndexPath) -> TreeNode {
        get {
            if indexPath.isEmpty {
                return self
            } else {
                return self.children[indexPath.first!][indexPath.dropFirst()]
            }
        }
        set {
            if indexPath.isEmpty {
                self = newValue
            } else {
                self.children[indexPath.first!][indexPath.dropFirst()] = newValue
            }
        }
    }

}
