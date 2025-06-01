package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import rl "vendor:raylib"

/*
    Based on: https://en.wikipedia.org/wiki/Rose_(mathematics)
*/

WIDTH :: 1024
HEIGHT ::  768
TITLE :: "Rose"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2
SIZE :: HEIGHT / 2 - 30

main :: proc() {
    k: f32 = 3
    ok: bool

    if len(os.args[1:]) > 0 {
        if k, ok = strconv.parse_f32(os.args[1]); !ok {
            fmt.eprintfln("Not a valid number: %s", os.args[1])
            os.exit(1)
        }
    }

    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)


    size := 0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        size += 1

        t: f32 = 0
        for i in 0..<size {
            t += 0.01

            x := MIDX + SIZE * math.cos(k * t) * math.cos(t)
            y := MIDY - SIZE * math.cos(k * t) * math.sin(t)
            rl.DrawCircle(i32(x), i32(y), 10, rl.ORANGE)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}