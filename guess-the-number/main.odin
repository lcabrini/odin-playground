package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import "core:strconv"
import "core:strings"

main :: proc() {
    min := 1
    max := 100
    guesses := 0
    secret := rand.int_max(max-min+1) + min

    if len(os.args) == 2 && strings.compare(os.args[1], "cheat") == 0 {
        fmt.printfln("The secret number is: %d", secret)
    }

    game: for {
        guess := read_number(min, max)
        guesses += 1

        switch {
            case guess < secret:
                fmt.println("Too low")
            case guess > secret:
                fmt.println("Too high")
            case:
                fmt.println("You got it!")
                fmt.printfln("You needed %d guess%s.", guesses, guesses == 1 ? "" : "es")
                break game
        }
    }
}

read_number :: proc (min, max: int) -> int {
    buf: [512]byte

    for {
        fmt.print("Your guess: ")
        num_bytes, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Error reading from stdin: ", err)
            return -1
        }

        s := string(buf[:num_bytes-1])
        n, ok := strconv.parse_int(s)
        if !ok {
            fmt.println("That's not a valid number. Try again")
            continue
        }

        if n < min || n > max {
            fmt.printfln("Your guess is outside of the valid range (%d-%d). Try again", min, max)
            continue
        }

        return n
    }
}