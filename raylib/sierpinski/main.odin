package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Sierpinski"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    size: f32 = 10
    degrees: i32 = 1

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.R) {
            size = 10
            degrees = 1
        }

        size += 2
        if i32(size) % 50 == 0 do degrees += 1
        if degrees > 8 do degrees = 8
        if size > 350 do size = 350

        rl.BeginDrawing()
        p1 := rl.Vector2{MIDX, MIDY-size}
        p2 := rl.Vector2{MIDX-size, MIDY+size}
        p3 := rl.Vector2{MIDX+size, MIDY+size}
        sierpinski(p1, p2, p3, degrees)
        rl.ClearBackground(rl.BLACK)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

sierpinski :: proc(p1, p2, p3: rl.Vector2, degree: i32) {
    if degree == 0 {
        rl.DrawTriangle(p1, p2, p3, rl.LIGHTGRAY)
        return
    }

    mid1 := (p1 + p2) / 2
    mid2 := (p2 + p3) / 2
    mid3 := (p3 + p1) / 2
    sierpinski(p1, mid1, mid3, degree - 1)
    sierpinski(mid1, p2, mid2, degree - 1)
    sierpinski(mid3, mid2, p3, degree - 1)
}