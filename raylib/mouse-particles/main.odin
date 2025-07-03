package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Mouse Particles"

PARTICLE_RADIUS :: 3
PARTICLE_AMOUNT :: 10
GRAVITY :: 0.3

Particle :: struct {
    pos: rl.Vector2,
    v: rl.Vector2,
    color: rl.Color,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    bg_texture := rl.LoadTexture("../../resources/space-bg.png")
    particles: [dynamic]Particle

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
            for i in 0..<PARTICLE_AMOUNT {
                mp := rl.GetMousePosition()
                p := Particle{}
                p.pos = {mp.x + f32(rl.GetRandomValue(-3, 3)), mp.y + f32(rl.GetRandomValue(-3, 3))}
                p.v = {f32(rl.GetRandomValue(-5, 5)), f32(rl.GetRandomValue(-5, 5))}
                p.color = {u8(rl.GetRandomValue(200, 255)), u8(rl.GetRandomValue(100, 255)), u8(rl.GetRandomValue(0, 50)), 255}
                append(&particles, p)
            }
        }

        for &p, i in particles {
            p.pos += p.v
            p.v.y += GRAVITY
            if p.color.r > 0 do p.color.r -= p.color.r >= 2 ? 2 : 1
            if p.color.g > 0 do p.color.g -= p.color.g >= 2 ? 2 : 1
            if p.color.b > 0 do p.color.b -= p.color.b >= 2 ? 2 : 1

            if p.color == rl.BLACK do unordered_remove(&particles, i)
        }

        rl.BeginDrawing()
        rl.DrawTexture(bg_texture, 0, 0, {100, 100, 100, 255})

        for p in particles{
            rl.DrawCircleV(p.pos, 2, p.color)
        }

        rl.EndDrawing()
    }

    rl.UnloadTexture(bg_texture)
    rl.CloseWindow()
}