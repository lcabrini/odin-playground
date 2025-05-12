package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import rl "vendor:raylib"

WIDTH :: 600
HEIGHT :: 600
TITLE :: "Rotated Squares"
MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    size_dec := f32(10.0)
    rot_amount := f32(15.0)
    ok: bool

    if len(os.args[1:]) > 0 {
        if size_dec, ok = strconv.parse_f32(os.args[1]); !ok {
            fmt.eprintfln("%s is not a valid number.", os.args[1])
            os.exit(-1)
        }
    }

    if len(os.args[1:]) > 1 {
        if rot_amount, ok = strconv.parse_f32(os.args[2]); !ok {
            fmt.eprintfln("%s is not a valid number", os.args[2])
            os.exit(-1)
        }
    }


    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    start_rot := f32(0)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rot := start_rot

        for size := f32(500.0); size > 0.0; size -= size_dec {
            x1 := MIDX + size/2 * math.sin(rot * rl.DEG2RAD)
            y1 := MIDY + size/2 * math.cos(rot * rl.DEG2RAD)

            x2 := MIDX + size/2 * math.sin((rot + 90) * rl.DEG2RAD)
            y2 := MIDY + size/2 * math.cos((rot + 90) * rl.DEG2RAD)

            x3 := MIDX + size/2 * math.sin((rot + 180) * rl.DEG2RAD)
            y3 := MIDY + size/2 * math.cos((rot + 180) * rl.DEG2RAD)

            x4 := MIDX + size/2 * math.sin((rot + 270) * rl.DEG2RAD)
            y4 := MIDY + size/2 * math.cos((rot + 270) * rl.DEG2RAD)

            rl.DrawLineV({x1, y1}, {x2, y2}, rl.RAYWHITE)
            rl.DrawLineV({x2, y2}, {x3, y3}, rl.RAYWHITE)
            rl.DrawLineV({x3, y3}, {x4, y4}, rl.RAYWHITE)
            rl.DrawLineV({x4, y4}, {x1, y1}, rl.RAYWHITE)

            rot += rot_amount
        }

        start_rot += 1

        rl.EndDrawing()
    }
}