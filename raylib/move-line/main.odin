package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Move Line"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    x1: i32 = MIDX - 200
    y1: i32 = MIDY
    x2: i32 = MIDX + 200
    y2: i32 = MIDY
    mark1 := false
    mark2 := false
    drag1 := false
    drag2 := false

    for !rl.WindowShouldClose() {
        mousepos := rl.GetMousePosition()

        d1 := math.sqrt(math.pow(mousepos.x - f32(x1), 2) + math.pow(mousepos.y - f32(y1), 2))
        mark1 = d1 < 10 ? true : false
        d2 := math.sqrt(math.pow(mousepos.x - f32(x2), 2) + math.pow(mousepos.y - f32(y2), 2))
        mark2 = d2 < 10 ? true : false

        if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
            if mark1 {
                drag1 = true
                mark1 = false
            }

            if mark2 {
                drag2 = true
                mark2 = false
            }
        }

        if rl.IsMouseButtonReleased(rl.MouseButton.LEFT) {
            drag1 = false
            drag2 = false
        }

        if drag1 {
            x1 = i32(mousepos.x)
            y1 = i32(mousepos.y)
        }

        if drag2 {
            x2 = i32(mousepos.x)
            y2 = i32(mousepos.y)
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawLine(x1, y1, x2, y2, rl.LIGHTGRAY)
        if mark1 do rl.DrawCircle(x1, y1, 10, rl.BLUE)
        if mark2 do rl.DrawCircle(x2, y2, 10, rl.BLUE)
        if drag1 do rl.DrawCircle(x1, y1, 10, rl.ORANGE)
        if drag2 do rl.DrawCircle(x2, y2, 10, rl.ORANGE)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}