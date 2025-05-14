package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Shooter"

MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    player := rl.LoadTexture("../../resources/soldier1_gun.png")
    rot: f32 = 0.0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        pw, ph := f32(player.width), f32(player.height)

        src := rl.Rectangle{0, 0, pw, ph}
        dest := rl.Rectangle{MIDX, MIDY, pw, ph}
        origin := rl.Vector2{16, ph / 2}

        //rot := f32(0.0)
        rl.DrawCircle(MIDX, MIDY, 50, rl.BLUE)
        rl.DrawTexturePro(player, src, dest, origin, rot, rl.RAYWHITE)
        rl.EndDrawing()
        rot += 1
    }

    rl.UnloadTexture(player)
    rl.CloseWindow()
}