package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Bouncing Ball"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

SPEED :: 300

Ball :: struct {
    pos: rl.Vector2,
    v: rl.Vector2,
    r: i32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    ball: Ball
    ball.pos = {MIDX, MIDY}
    ball.v = {SPEED, SPEED}
    ball.r = 50

    for !rl.WindowShouldClose() {
        ball.pos += ball.v * rl.GetFrameTime()

        if ball.pos.x - f32(ball.r) <= 0 || ball.pos.x + f32(ball.r) > WIDTH {
            ball.v.x *= -1
        }

        if ball.pos.y - f32(ball.r) <= 0 || ball.pos.y + f32(ball.r) > HEIGHT {
            ball.v.y *= -1
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawCircleV(ball.pos, 50, rl.GREEN)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}