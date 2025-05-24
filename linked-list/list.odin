package main

Node :: struct($Data: typeid) {
    data: Data,
    next: ^Node(Data),
}

List :: struct($Data: typeid) {
    head: ^Node(Data),
    tail: ^Node(Data),
    count: int,
}

append_node :: proc(list: ^List($T), data: T) {
    node := new(Node(T))
    node.data = data

    if list.head == nil {
        list.head = node
        list.tail = node
    } else {
        list.tail.next = node
        list.tail = node
    }

    list.count += 1
}

traverse_list :: proc(list: List($T), cb: proc(T)) {
    for node := list.head; node != nil; node = node.next {
        //fmt.println(node.data)
        cb(node.data)
    }
}

free_list :: proc(list: List($T)) {
    node := list.head
    for node != nil {
        next := node.next
        free(node)
        node = node.next
    }
}