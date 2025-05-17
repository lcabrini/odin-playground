package main

import "core:fmt"
import "core:math/rand"
import "core:os"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Guess the Toggles"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    secret := u8(rl.GetRandomValue(0, 255))

    if len(os.args[1:]) > 0 && os.args[1] == "cheat" {
        fmt.println(secret)
        fmt.printfln("CHEAT MODE: SECRET: %s", to_binary(secret))
    }

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

to_binary :: proc(n: u8) -> string {
    s := ""

    for g := u8(128); g > 0; g >>= 1 {
        s = fmt.tprintf("%s%s", s, g & n == 0 ? "0" : "1")
    }

    return s
}
