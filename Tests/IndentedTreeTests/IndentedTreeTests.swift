@testable import IndentedTree
import XCTest

final class IndentedTreeTests: XCTestCase {

    let recursiveTree =
        TreeNode(content: "root", children: [
            TreeNode(content: "a", children: [
                TreeNode(content: "a.1"),
                TreeNode(content: "a.2"),
            ]),
            TreeNode(content: "b"),
        ])

    let indentedTree = [
        IndentedTreeNode(indent: 0, content: "root"),
        IndentedTreeNode(indent: 1, content: "a"),
        IndentedTreeNode(indent: 2, content: "a.1"),
        IndentedTreeNode(indent: 2, content: "a.2"),
        IndentedTreeNode(indent: 1, content: "b"),
    ]

    let recursiveSingleNode = TreeNode(content: "root")
    let indentedSingleNode = [IndentedTreeNode(indent: 0, content: "root")]

    func testFlattenSingleNode() {
        XCTAssertEqual(flatten(self.recursiveSingleNode), self.indentedSingleNode)
    }

    func testFlatten() {
        XCTAssertEqual(flatten(self.recursiveTree), self.indentedTree)
    }

    func testUnflattenEmpty() {
        let empty = [IndentedTreeNode<String>]()
        XCTAssertNil(unflatten(empty))
    }

    func testUnflattenSingleNode() {
        XCTAssertEqual(unflatten(self.indentedSingleNode), self.recursiveSingleNode)
    }

    func testUnflatten() {
        XCTAssertEqual(unflatten(self.indentedTree), self.recursiveTree)
    }

    func testUnflattenDeindentJump() {

        let tree =
            TreeNode(content: "root", children: [
                TreeNode(content: "a", children: [
                    TreeNode(content: "aaa", children: [
                        TreeNode(content: "aaaa"),
                    ]),
                ]),
                TreeNode(content: "b"),
            ])

        XCTAssertEqual(unflatten(flatten(tree)), tree)

    }

    func testUnflattenInvalidIndentIgnored() {

        let indentedTree = [
            IndentedTreeNode(indent: 0, content: "root"),
            IndentedTreeNode(indent: 1, content: "a"),
            IndentedTreeNode(indent: 5, content: "a.1"),
            IndentedTreeNode(indent: 2, content: "a.2"),
            IndentedTreeNode(indent: 1, content: "b"),
        ]

        XCTAssertEqual(unflatten(indentedTree), recursiveTree)

    }

    func testSubscriptGet() {
        let tree = self.recursiveTree
        XCTAssertEqual(tree[IndexPath()].content, "root")
        XCTAssertEqual(tree[IndexPath(indexes: [0])].content, "a")
        XCTAssertEqual(tree[IndexPath(indexes: [0, 1])].content, "a.2")
    }

    func testSubscriptSet() {
        var tree = self.recursiveTree
        tree[IndexPath(indexes: [0, 1])].content = "a.2-changed"

        var expected = self.recursiveTree
        expected.children[0].children[1].content = "a.2-changed"

        XCTAssertEqual(tree, expected)
    }

}
