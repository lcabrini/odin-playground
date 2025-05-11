package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import rl "vendor:raylib"

main :: proc() {
    width := read_size("Enter the window width", 100, 1024)
    height := read_size("Enter the window height", 100, 768)
    title := read_title("Enter the window title")

    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(width, height, title)
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

read_size :: proc(prompt: string, min, max: int) -> i32 {
    buf: [100]byte

    for {
        fmt.printf("%s (%d-%d): ", prompt, min, max)
        nb, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Unable to read from stdin:", err)
            os.exit(-1)
        }

        s := string(buf[:nb-1])
        n, ok := strconv.parse_int(s)
        if !ok {
            fmt.printfln("%s is not a valid number. Try again", s)
            continue
        }

        if n < min || n > max {
            fmt.printfln("%d is outside the accepted range (%d-%d). Try again", n, min, max)
            continue
        }

        return i32(n)
    }
}

read_title :: proc(prompt: string) -> cstring {
    buf: [100]byte

    for {
        fmt.printf("%s: ", prompt)
        nb, err := os.read(os.stdin, buf[:])
        if err != nil {
            fmt.eprintln("Unable to read from stdin:", err)
            os.exit(-1)
        }

        s := string(buf[:nb-1])
        is_empty := strings.compare(s, "") == 0
        if is_empty {
            fmt.println("You have to type a title. Try again.")
            continue
        }

        return strings.clone_to_cstring(s)
    }
}