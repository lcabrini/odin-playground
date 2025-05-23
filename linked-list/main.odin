package main

import "core:fmt"

Node :: struct($Data: typeid) {
    data: Data,
    next: ^Node(Data),
}

List :: struct($Data: typeid) {
    head: ^Node(Data),
    tail: ^Node(Data),
    count: int,
}

Language :: struct {
    name: string,
    creator: string,
}

main :: proc() {
    slist: List(string)
    ilist: List(int)
    llist: List(Language)
    days := []string{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
    langs := []Language{
        {"Odin", "GingerBill"},
        {"C", "Dennis Ritchie"},
        {"C++", "Bjarne Strousrup"},
        {"Perl", "Larry Wall"},
    }

    for i in 1..=10 {
        append_node(&ilist, i)
    }

    for d in days {
        append_node(&slist, d)
    }

    for l in langs {
        append_node(&llist, l)
    }

    traverse_list(ilist, printi)
    fmt.println("--------------------------------------")
    traverse_list(slist, prints)
    fmt.println("--------------------------------------")
    traverse_list(llist, printlang)

    free_list(ilist)
    free_list(slist)
    free_list(llist)
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

printi :: proc(n: int) {
    fmt.printfln("List contains integer node: %d", n)
}

prints :: proc(s: string) {
    fmt.printfln("List containst string: %s", s)
}

printlang :: proc(l: Language) {
    fmt.printfln("%s was created by %s", l.name, l.creator)
}

free_list :: proc(list: List($T)) {
    node := list.head
    for node != nil {
        next := node.next
        free(node)
        node = node.next
    }
}