package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Lissajous Curve"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    a: f32 = 3
    b: f32 = 4
    delta: f32 = math.PI / 2

    if len(os.args[1:]) > 0 {
        a = parse_f32_or_fail(os.args[1])
    }

    if len(os.args[1:]) > 1 {
        b = parse_f32_or_fail(os.args[2])
    }

    if len(os.args[1:]) > 2 {
        delta = parse_f32_or_fail(os.args[3])
    }

    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)
    size := 0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        t: f32 = 0.0
        size += 1

        for i in 0..<size {
            t += 0.01
            if t > math.PI * 2 do break
            x := MIDX + 500 * math.sin(a * f32(t) + delta)
            y := MIDY + 300 * math.sin(b * f32(t))

            rl.DrawCircle(i32(x), i32(y), 10, rl.BLUE)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

parse_f32_or_fail :: proc(s: string) -> f32 {
    f, ok := strconv.parse_f32(s)
    if !ok {
        fmt.eprintfln("Not a valid floating-point number: %s", s)
        os.exit(1)
    }

    return f
}