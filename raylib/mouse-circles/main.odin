package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Mouse Circles"

Circle :: struct {
    pos: rl.Vector2,
    color: rl.Color,
    radius: i32
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    circles: [dynamic]Circle

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
            r := u8(rl.GetRandomValue(0, 255))
            g := u8(rl.GetRandomValue(0, 255))
            b := u8(rl.GetRandomValue(0, 255))
            c := Circle{}
            c.pos = rl.GetMousePosition()
            c.color = {r, g, b, 255}
            c.radius = 1
            append(&circles, c)
        }

        for &circle, i in circles {
            circle.radius += 1
            if circle.radius > 200 {
                if circle.color.r > 0 do circle.color.r -= 1
                if circle.color.g > 0 do circle.color.g -= 1
                if circle.color.b > 0 do circle.color.b -= 1
            }

            if circle.color == rl.BLACK do ordered_remove(&circles, i)
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for circle in circles {
            rl.DrawCircleLinesV(circle.pos, f32(circle.radius), circle.color)
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}