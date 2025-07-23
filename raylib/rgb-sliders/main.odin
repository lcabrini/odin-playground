package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "RGB Sliders"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    red: f32
    green: f32
    blue: f32

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawRectangle(0, 0, WIDTH, MIDY, rl.RAYWHITE)
        color := rl.Color{u8(red), u8(green), u8(blue), 255}
        rl.DrawRectangle(20, 20, WIDTH-40, MIDY-40, color)

        rl.GuiSliderBar({50, MIDY+50, WIDTH-100, 30}, "Red", rl.TextFormat("%d", u8(red)), &red, 0, 255)
        rl.GuiSliderBar({50, MIDY+90, WIDTH-100, 30}, "Green", rl.TextFormat("%d", u8(green)), &green, 0, 255)
        rl.GuiSliderBar({50, MIDY+130, WIDTH-100, 30}, "Blue", rl.TextFormat("%d", u8(blue)), &blue, 0, 255)
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
