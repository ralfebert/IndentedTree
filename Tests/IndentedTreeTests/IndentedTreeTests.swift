@testable import IndentedTree
import XCTest

final class IndentedTreeTests: XCTestCase {

    let nestedTree =
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

    let nestedSingleNode = TreeNode(content: "root")
    let indentedSingleNode = [IndentedTreeNode(indent: 0, content: "root")]

    func testFlattenSingleNode() {
        XCTAssertEqual(flatten(self.nestedSingleNode), self.indentedSingleNode)
    }

    func testFlatten() {
        XCTAssertEqual(flatten(self.nestedTree), self.indentedTree)
    }

    func testUnflattenEmpty() {
        let empty = [IndentedTreeNode<String>]()
        XCTAssertNil(unflatten(empty))
    }

    func testUnflattenSingleNode() {
        XCTAssertEqual(unflatten(self.indentedSingleNode), self.nestedSingleNode)
    }

    func testUnflatten() {
        XCTAssertEqual(unflatten(self.indentedTree), self.nestedTree)
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
            IndentedTreeNode(indent: -3, content: "b"),
        ]

        XCTAssertEqual(unflatten(indentedTree), nestedTree)

    }

    func testSubscriptGet() {
        let tree = self.nestedTree
        XCTAssertEqual(tree[IndexPath()].content, "root")
        XCTAssertEqual(tree[IndexPath(indexes: [0])].content, "a")
        XCTAssertEqual(tree[IndexPath(indexes: [0, 1])].content, "a.2")
    }

    func testSubscriptSet() {
        var tree = self.nestedTree
        tree[IndexPath(indexes: [0, 1])].content = "a.2-changed"

        var expected = self.nestedTree
        expected.children[0].children[1].content = "a.2-changed"

        XCTAssertEqual(tree, expected)
    }

}
