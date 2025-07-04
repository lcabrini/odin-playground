package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Cannon"

CANNON_SPEED :: 150

Cannon :: struct {
    pos: rl.Vector2,
    angle: f32,
    power: f32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    cannon := Cannon{}
    cannon.pos = {50, HEIGHT-30-25}

    for !rl.WindowShouldClose() {
        if rl.IsKeyDown(.A) {
            cannon.pos.x -= CANNON_SPEED * rl.GetFrameTime()
            if cannon.pos.x < 50 do cannon.pos.x = 50
        }

        if rl.IsKeyDown(.D) {
            cannon.pos.x += CANNON_SPEED * rl.GetFrameTime()
            if cannon.pos.x > WIDTH - 50 do cannon.pos.x = WIDTH - 50
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        rl.DrawRectangle(0, HEIGHT-30, WIDTH, 30, rl.GREEN)

        rl.DrawCircleV(cannon.pos, 25, rl.BLACK)

        rl.DrawRectanglePro({cannon.pos.x, cannon.pos.y, 40, 20}, {0, 10}, cannon.angle, rl.BLACK)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}