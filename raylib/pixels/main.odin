package main

import rl "vendor:raylib"

/*
    Lightly inspired by graphdemo that demonstrated the graph unit which came
    with Turbo Pascal back in the days when the world was young.
*/

WORKBENCH_BLUE :: rl.Color{0, 85, 169, 255}

WIDTH :: 1024
HEIGHT :: 748
TITLE :: "Pixels"

HUD_HEIGHT :: 100

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    image := rl.LoadImageFromScreen()
    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()

        x := rl.GetRandomValue(0, WIDTH-1)
        y := rl.GetRandomValue(HUD_HEIGHT+1, HEIGHT-1)
        r := rl.GetRandomValue(0, 255)
        g := rl.GetRandomValue(0, 255)
        b := rl.GetRandomValue(0, 255)
        rl.ImageDrawPixel(&image, x, y, {u8(r), u8(g), u8(b), 255})

        texture := rl.LoadTextureFromImage(image)
        rl.DrawTexture(texture, 0, 0, rl.RAYWHITE)

        rl.DrawRectangle(0, 0, WIDTH, HUD_HEIGHT, WORKBENCH_BLUE)
        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.UnloadImage(image)
    rl.CloseWindow()
}