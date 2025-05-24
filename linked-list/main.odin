package main

import "core:fmt"


Language :: struct {
    name: string,
    creator: string,
}

main :: proc() {
    slist: ^Node(string)
    ilist: ^Node(int)
    llist: ^Node(Language)

    days := []string{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"}
    langs := []Language{
        {"Odin", "GingerBill"},
        {"C", "Dennis Ritchie"},
        {"C++", "Bjarne Strousrup"},
        {"Perl", "Larry Wall"},
    }

    for i in 1..=10 {
        ilist = append_node(ilist, i)
    }

    for d in days {
        slist = append_node(slist, d)
    }

    for l in langs {
        llist = append_node(llist, l)
    }

    fmt.printfln("Length of string list: %d", list_count(slist))
    fmt.printfln("Length to int list: %d", list_count(ilist))
    fmt.printfln("Length of language list: %d", list_count(llist))
    fmt.println("--------------------------------------")

    traverse_list(ilist, printi)
    fmt.println("--------------------------------------")
    traverse_list(slist, prints)
    fmt.println("--------------------------------------")
    traverse_list(llist, printlang)

    free_list(ilist)
    free_list(slist)
    free_list(llist)
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
