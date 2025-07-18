package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Perlin Noise"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    image := rl.GenImagePerlinNoise(WIDTH, HEIGHT, 0, 0, 1.5)
    texture := rl.LoadTextureFromImage(image)
    
    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.DrawTexture(texture, 0, 0, rl.WHITE)
        rl.EndDrawing()
    }

    rl.UnloadImage(image)
    rl.UnloadTexture(texture)
    rl.CloseWindow()
}
