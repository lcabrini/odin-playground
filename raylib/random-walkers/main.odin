package main

import rl "vendor:raylib"

/*
    Adapted from https://happycoding.io/tutorials/processing/arraylists/random-walkers
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Random Walkers"


Walker :: struct {
    pos: rl.Vector2,
    color: rl.Color,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    target := rl.LoadRenderTexture(WIDTH, HEIGHT)
    walkers: [dynamic]Walker

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
            mp := rl.GetMousePosition()
            r := u8(rl.GetRandomValue(0, 255))
            g := u8(rl.GetRandomValue(0, 255))
            b := u8(rl.GetRandomValue(0, 255))
            walker := Walker{}
            walker.pos = mp
            walker.color = {r, g, b, 255}
            append(&walkers, walker)
        }

        rl.BeginTextureMode(target)
        for &walker in walkers {
            walker.pos.x += f32(rl.GetRandomValue(-1, 1))
            walker.pos.y += f32(rl.GetRandomValue(-1, 1))

            if walker.pos.x > WIDTH do walker.pos.x = 0
            if walker.pos.x < 0 do walker.pos.x = WIDTH
            if walker.pos.y > HEIGHT do walker.pos.y = 0
            if walker.pos.y < 0 do walker.pos.y = HEIGHT
            rl.DrawPixelV(walker.pos, walker.color)
        }
        rl.EndTextureMode()

        rl.BeginDrawing()
        rl.DrawTextureRec(target.texture, {0, 0, WIDTH, -HEIGHT}, {0, 0}, rl.WHITE)
        rl.EndDrawing()
    }

    rl.UnloadRenderTexture(target)
    rl.CloseWindow()
}
