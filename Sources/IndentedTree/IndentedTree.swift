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
    guard let firstNode = list.first?.content else { return nil }
    let remainingNodes = list.dropFirst()

    var root = TreeNode(content: firstNode)
    var lastNodePath = IndexPath()

    for node in remainingNodes {
        let pathToNodeParent = lastNodePath.prefix(max(node.indent, 1) - 1)
        var children = root[pathToNodeParent].children
        children.append(TreeNode(content: node.content))
        root[pathToNodeParent].children = children
        lastNodePath = pathToNodeParent.appending(children.indices.last!)
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

extension TreeNode: CustomStringConvertible {

    public var description: String {
        flatten(self)
            .map { String(repeating: "\t", count: $0.indent) + "\($0.content)" }
            .joined(separator: "\n")
    }

}
