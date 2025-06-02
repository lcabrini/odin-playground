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
    r: f32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.InitAudioDevice()

    hit := rl.LoadSound("../../resources/classic-punch-impact.mp3")

    ball: Ball
    ball.pos = {MIDX, MIDY}
    ball.v = {SPEED, SPEED}
    ball.r = 50

    newpos := rl.Vector2{}
    redirecting := false
    paused := false
    pause_counter := 0
    show_pause := false

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
            pause_counter = 0
            show_pause = true
        }

        if paused {
            pause_counter += 1
            if pause_counter % 80 == 0 {
                show_pause = !show_pause
            }
        }

        if !paused {
            if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
                newpos = rl.GetMousePosition()
                redirecting = true
            }

            if rl.IsMouseButtonReleased(rl.MouseButton.LEFT) {
                newv := rl.GetMousePosition() - newpos
                ball.pos = newpos
                ball.v = newv
                redirecting = false
            }

            ball.pos += ball.v * rl.GetFrameTime()

            if ball.pos.x - ball.r <= 0 || ball.pos.x + ball.r > WIDTH {
                ball.v.x *= -1
                if ball.pos.x - ball.r < 0 do ball.pos.x = ball.r
                if ball.pos.x + ball.r > WIDTH do ball.pos.x = WIDTH - ball.r
                rl.PlaySound(hit)
            }

            if ball.pos.y - ball.r <= 0 || ball.pos.y + ball.r > HEIGHT {
                ball.v.y *= -1
                if ball.pos.y - ball.r < 0 do ball.pos.y = ball.r
                if ball.pos.y + ball.r > HEIGHT do ball.pos.y = HEIGHT - ball.r
                rl.PlaySound(hit)
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.DrawCircleV(ball.pos, 50, rl.GREEN)
        if redirecting {
            rl.DrawLineV(newpos, rl.GetMousePosition(), rl.BLUE)
        }

        if paused && show_pause {
            rl.DrawText("P", 10, 10, 100, rl.RAYWHITE)
        }

        rl.EndDrawing()
    }

    rl.UnloadSound(hit)
    rl.CloseAudioDevice()
    rl.CloseWindow()
}