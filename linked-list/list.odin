package main

import "core:fmt"

Node :: struct($Data: typeid) {
    data: Data,
    next: ^Node(Data),
}

append_node :: proc(list: ^Node($T), data: T) -> ^Node(T) {
    node := new(Node(T))
    node.data = data

    head := list
    tail := get_tail(list)

    if tail == nil {
        head = node
    } else {
        tail.next = node
    }

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
        node = node.next
    }
}

get_tail :: proc(head: ^Node($T)) -> ^Node(T) {
    tail := head
    for node := head; node != nil; node = node.next {
        tail = node
    }
    return tail
}

list_count :: proc(list: ^Node($T)) -> int {
    count := 0

    for node := list; node != nil; node = node.next {
        count += 1
    }

    return count
}