package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Drag'n'Drop"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    texture := rl.LoadTexture("../../resources/raylib-logo.png")
    tw := f32(texture.width)
    th := f32(texture.height)
    xpos := MIDX - tw / 2
    ypos := MIDY - th / 2
    drag := false

    for !rl.WindowShouldClose() {
        mp := rl.GetMousePosition()
        mouse_over := false
        if mp.x > xpos && mp.x < xpos + tw {
            if mp.y > ypos && mp.y < ypos + th {
                mouse_over = true
            }
        }

        if mouse_over && rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
            drag = true
        }

        if drag && !rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
            drag = false
        }

        if drag {
            delta := rl.GetMouseDelta()
            xpos += delta.x
            ypos += delta.y
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawTextureEx(texture, {xpos, ypos}, 0, 1, rl.WHITE)
        if mouse_over {
            rec := rl.Rectangle{xpos - 1, ypos - 1, tw + 2, th + 2}
            rl.DrawRectangleLinesEx(rec, 1, rl.GREEN)
        }

        rl.EndDrawing()
    }
}