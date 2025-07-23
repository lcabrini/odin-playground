package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "RGB Sliders"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    red: f32
    green: f32
    blue: f32

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawRectangle(10, 10, WIDTH-20, 200, rl.RAYWHITE)
        color := rl.Color{u8(red), u8(green), u8(blue), 255}
        rl.DrawRectangle(20, 20, WIDTH-40, 180, color)

        rl.GuiSliderBar({50, 310, WIDTH-100, 30}, "Red", rl.TextFormat("%d", u8(red)), &red, 0, 255)
        rl.GuiSliderBar({50, 350, WIDTH-100, 30}, "Green", rl.TextFormat("%d", u8(green)), &green, 0, 255)
        rl.GuiSliderBar({50, 390, WIDTH-100, 30}, "Blue", rl.TextFormat("%d", u8(blue)), &blue, 0, 255)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
