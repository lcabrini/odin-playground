package main

import "core:fmt"

main :: proc() {
    queue: Queue(string)

    enqueue(&queue, "Sunday")
    enqueue(&queue, "Monday")
    enqueue(&queue, "Tuesday")
    enqueue(&queue, "Wednesday")
    enqueue(&queue, "Thursday")
    enqueue(&queue, "Friday")
    enqueue(&queue, "Saturday")

    for !queue_is_empty(&queue) {
        fmt.printfln("%s", dequeue(&queue))
    }

    free_queue(&queue)
}