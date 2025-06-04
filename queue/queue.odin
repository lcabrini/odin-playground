package main

Node :: struct($Data: typeid) {
    data: Data,
    next: ^Node(Data),
}

Queue :: struct($Data: typeid) {
    head: ^Node(Data),
    tail: ^Node(Data),
}

enqueue :: proc(queue: ^Queue($T), data: T) {
    node := new(Node(T))
    node.data = data
    if queue.head == nil {
        queue.head = node
        queue.tail = node
    } else {
        queue.tail.next = node
        queue.tail = node
    }
}

dequeue :: proc(queue: ^Queue($T)) -> T {
    data: T

    if queue.head != nil {
        data = queue.head.data
        head := queue.head
        queue.head = queue.head.next
        free(head)
    }

    return data
}

queue_is_empty :: proc(queue: ^Queue($T)) -> bool {
    return queue.head == nil
}

free_queue :: proc(queue: ^Queue($T)) {
    node := queue.head
    for node != nil {
        next := node.next
        free(node)
        node = next
    }
}