package main

import "core:math/rand"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Sierpinski"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

MIN_SIZE :: 10
MAX_SIZE :: 350
SIZE_STEP :: 2
MIN_DEGREES :: 1
MAX_DEGREES :: 8
DEGREES_STEP :: 1
DEGREES_CYCLE :: 50

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    colors := []rl.Color{rl.BLUE, rl.RED, rl.GREEN, rl.YELLOW, rl.LIGHTGRAY, rl.ORANGE}
    size: f32 = MIN_SIZE
    degrees: i32 = MIN_DEGREES
    color := rand.choice(colors[:])

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.R) {
            size = MIN_SIZE
            degrees = MIN_DEGREES
            color = rand.choice(colors)
        }

        size += SIZE_STEP
        if i32(size) % DEGREES_CYCLE == 0 do degrees += DEGREES_STEP
        if degrees > MAX_DEGREES do degrees = MAX_DEGREES
        if size > MAX_SIZE do size = MAX_SIZE

        rl.BeginDrawing()
        p1 := rl.Vector2{MIDX, MIDY-size}
        p2 := rl.Vector2{MIDX-size, MIDY+size}
        p3 := rl.Vector2{MIDX+size, MIDY+size}

        sierpinski(p1, p2, p3, degrees, color)
        rl.ClearBackground(rl.BLACK)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}

sierpinski :: proc(p1, p2, p3: rl.Vector2, degree: i32, color: rl.Color) {
    if degree == 0 {
        rl.DrawTriangle(p1, p2, p3, color)
        return
    }

    mid1 := (p1 + p2) / 2
    mid2 := (p2 + p3) / 2
    mid3 := (p3 + p1) / 2
    sierpinski(p1, mid1, mid3, degree - 1, color)
    sierpinski(mid1, p2, mid2, degree - 1, color)
    sierpinski(mid3, mid2, p3, degree - 1, color)
}