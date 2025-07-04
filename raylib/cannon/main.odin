package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Cannon"

CANNON_SPEED :: 150
MIN_POWER :: 300
MAX_POWER :: 2000

Cannon :: struct {
    pos: rl.Vector2,
    angle: f32,
    power: f32,
}

Ball :: struct {
    pos: rl.Vector2,
    v: rl.Vector2,
    fired: bool,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)

    bg_texture := rl.LoadTexture("../../resources/backgroundColorForest.png")

    cannon := Cannon{}
    cannon.pos = {50, HEIGHT-30-25}
    cannon.power = MIN_POWER
    ball := Ball{}

    for !rl.WindowShouldClose() {
        if rl.IsKeyDown(.A) {
            cannon.pos.x -= CANNON_SPEED * rl.GetFrameTime()
            if cannon.pos.x < 50 do cannon.pos.x = 50
        }

        if rl.IsKeyDown(.D) {
            cannon.pos.x += CANNON_SPEED * rl.GetFrameTime()
            if cannon.pos.x > WIDTH - 50 do cannon.pos.x = WIDTH - 50
        }

        if rl.IsKeyDown(.LEFT) {
            cannon.angle -= 1
            if cannon.angle < -180 do cannon.angle = -180
        }

        if rl.IsKeyDown(.RIGHT) {
            cannon.angle += 1
            if cannon.angle > 0 do cannon.angle = 0
        }

        if rl.IsKeyDown(.UP) {
            cannon.power += 10
            if cannon.power > MAX_POWER do cannon.power = MAX_POWER
        }

        if rl.IsKeyDown(.DOWN) {
            cannon.power -= 10
            if cannon.power < MIN_POWER do cannon.power = MIN_POWER
        }

        if rl.IsKeyPressed(.SPACE) && !ball.fired {
            ball.pos = cannon.pos
            ball.v.x = cannon.power * math.cos(cannon.angle * rl.DEG2RAD)
            ball.v.y = cannon.power * math.sin(cannon.angle * rl.DEG2RAD)
            ball.fired = true
        }

        if ball.fired {
            ball.pos += ball.v * rl.GetFrameTime()
            ball.v.y += 200 * rl.GetFrameTime()
        }

        if ball.pos.x < 0 || ball.pos.x > WIDTH {
            ball.fired = false
        }

        if ball.pos.y > HEIGHT {
            ball.fired = false
        }

        rl.BeginDrawing()
        rl.ClearBackground({206, 239, 252, 255})

        for x: i32 = 0; x < WIDTH; x += bg_texture.width {
            rl.DrawTexture(bg_texture, x, HEIGHT - bg_texture.height, rl.WHITE)
        }

        rl.DrawRectangle(10, 10, 202, 20, rl.DARKBLUE)
        rl.DrawRectangle(11, 11, i32((cannon.power) / 10), 18, rl.BLUE)

        if ball.fired {
            rl.DrawCircleV(ball.pos, 10, rl.BLACK)
        }

        rl.DrawCircleV(cannon.pos, 25, rl.BLACK)
        rl.DrawRectanglePro({cannon.pos.x, cannon.pos.y, 40, 20}, {0, 10}, cannon.angle, rl.BLACK)
        rl.EndDrawing()
    }

    rl.UnloadTexture(bg_texture)
    rl.CloseWindow()
}