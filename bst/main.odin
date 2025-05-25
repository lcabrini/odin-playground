package main

import "core:fmt"

Person :: struct {
    name: string,
    age: int,
}

main :: proc() {
    root: ^Node(int)

    root = insert_node(root, 50, int_comparator)
    root = insert_node(root, 30, int_comparator)
    root = insert_node(root, 20, int_comparator)
    root = insert_node(root, 40, int_comparator)
    root = insert_node(root, 70, int_comparator)
    root = insert_node(root, 60, int_comparator)
    root = insert_node(root, 80, int_comparator)

    ordered_traversal(root, printi)

    fmt.println("----------------------------------------------")

    pr: ^Node(Person)

    pr = insert_node(pr, Person{"James", 50}, person_comparator)
    pr = insert_node(pr, Person{"Pete", 30}, person_comparator)
    pr = insert_node(pr, Person{"Anna", 20}, person_comparator)
    pr = insert_node(pr, Person{"Brandon", 40}, person_comparator)
    pr = insert_node(pr, Person{"Maria", 70}, person_comparator)
    pr = insert_node(pr, Person{"John", 60}, person_comparator)
    pr = insert_node(pr, Person{"David", 80}, person_comparator)

    ordered_traversal(pr, print_person)
}

printi :: proc(n: int) {
    fmt.println(n)
}

print_person :: proc(t: Person) {
    fmt.printfln("%s is %d years old", t.name, t.age)
}

int_comparator :: proc(a, b: int) -> int {
    return a - b
}

person_comparator :: proc(a, b: Person) -> int {
    return a.age - b.age
}