package main

import "core:fmt"

Node :: struct ($Data: typeid) {
    data: Data,
    left: ^Node(Data),
    right: ^Node(Data),
}

insert_node :: proc(node: ^Node($T), data: T, comparator: proc(T, T) -> int) -> ^Node(T) {
    if node == nil {
        n := new(Node(T))
        n.data = data
        return n
    }

    if comparator(node.data, data) == 0 {
        return node
    }

    if comparator(node.data, data) < 0 {
        node.right = insert_node(node.right, data, comparator)
    } else {
        node.left = insert_node(node.left, data, comparator)
    }

    return node
}

ordered_traversal :: proc(root: ^Node($T), cb: proc(T)) {
    if root != nil {
        ordered_traversal(root.left, cb)
        cb(root.data)
        ordered_traversal(root.right, cb)
    }
}
