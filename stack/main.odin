package main

import "core:fmt"

main :: proc() {
    stack: Stack(string)

    stack_push(&stack, "foo")
    stack_push(&stack, "bar")
    stack_push(&stack, "bim")

    for !stack_is_empty(&stack) {
        fmt.println(stack_pop(&stack))
    }

    free_stack(&stack)
}