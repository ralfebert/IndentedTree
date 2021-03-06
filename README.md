# IndentedTree

A tiny Swift package that provides value types to represent trees in a nested data structure:

```swift
let nestedTree =
    TreeNode(content: "root", children: [
        TreeNode(content: "a", children: [
            TreeNode(content: "a.1"),
            TreeNode(content: "a.2"),
        ]),
        TreeNode(content: "b"),
    ])
```

or a flat data structure:

```swift
let indentedTree = [
    IndentedTreeNode(indent: 0, content: "root"),
    IndentedTreeNode(indent: 1, content: "a"),
    IndentedTreeNode(indent: 2, content: "a.1"),
    IndentedTreeNode(indent: 2, content: "a.2"),
    IndentedTreeNode(indent: 1, content: "b"),
]
```

The nested form supports access by index path:

```swift
nestedTree[IndexPath(indexes: [0, 1])] == "a.2"
```

There are functions to convert between the two forms of representation:

```swift
let indentedTree = flatten(nestedTree)
let nestedTree = unflatten(indentedTree)
```

Discussion about these data structures:   
https://stackoverflow.com/questions/58398986/converting-between-recursive-indented-tree-data-structure/58402323#58402323
