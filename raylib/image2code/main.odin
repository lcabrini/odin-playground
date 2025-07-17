package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Image 2 Code"

main :: proc() {
    //rl.SetConfigFlags({.VSYNC_HINT})
    //rl.InitWindow(WIDTH, HEIGHT, TITLE)
    //rl.SetTargetFPS(60)

    image := rl.LoadImage("../../resources/space-bg.png")
    rl.ExportImageAsCode(image, "export.c")
    rl.UnloadImage(image)
    //rl.CloseWindow()
}
