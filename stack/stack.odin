package main

Node :: struct($Data: typeid) {
    data: Data,
    next: ^Node(Data),
}

Stack :: struct($Data: typeid) {
    top: ^Node(Data)
}

stack_push :: proc(stack: ^Stack($T), data: T) {
    node := new(Node(T))
    node.data = data
    node.next = stack.top
    stack.top = node
}

stack_pop :: proc(stack: ^Stack($T)) -> T {
    data: T

    top := stack.top
    if top != nil {
        data = top.data
        stack.top = top.next
        free(top)
    }

    return data
}

stack_is_empty :: proc(stack: ^Stack($T)) -> bool {
    return stack.top == nil
}

free_stack :: proc(stack: ^Stack($T)) {
    node := stack.top
    for node != nil {
        next := node.next
        free(node)
        node = next
    }
}