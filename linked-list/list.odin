package main

import "core:fmt"

Node :: struct($Data: typeid) {
    data: Data,
    next: ^Node(Data),
}

append_node :: proc(head: ^Node($T), data: T) -> ^Node(T) {
    node := new(Node(T))
    node.data = data

    tail := get_tail(head)

    if tail == nil {
        return node
    } else {
        tail.next = node
    }

    return head
}

prepend_node :: proc(head: ^Node($T), data: T) -> ^Node(T) {
    node := new(Node(T))
    node.data = data
    node.next = head
    return node
}

insert_node_at :: proc(head: ^Node($T), pos: int, data: T) -> ^Node(T) {
    if pos < 1 {
        return head
    }

    curr := head
    for i in 1..<pos {
        curr = curr.next
        if curr == nil {
            return head
        }
    }

    node := new(Node(T))
    node.data = data
    node.next = curr.next
    curr.next = node

    return head
}

traverse_list :: proc(head: ^Node($T), cb: proc(T)) {
    for node := head; node != nil; node = node.next {
        cb(node.data)
    }
}

free_list :: proc(head: ^Node($T)) {
    node := head
    for node != nil {
        next := node.next
        free(node)
        node = next
    }
}

get_tail :: proc(head: ^Node($T)) -> ^Node(T) {
    curr := head
    for node := head; node != nil; node = node.next {
        curr = node
    }
    return curr
}

list_count :: proc(list: ^Node($T)) -> int {
    count := 0

    for node := list; node != nil; node = node.next {
        count += 1
    }

    return count
}