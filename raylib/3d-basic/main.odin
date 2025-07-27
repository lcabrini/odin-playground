package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGTH :: 768
TITLE :: "3D Basic"

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.SetTraceLogLevel(.ERROR)
    rl.InitWindow(WIDTH, HEIGTH, TITLE)
    rl.SetTargetFPS(60)

    camera := rl.Camera3D{}
    camera.position = {0, 10, 10}
    camera.target = {0, 0, 0}
    camera.up = {0, 1, 0}
    camera.fovy = 45
    camera.projection = rl.CameraProjection.PERSPECTIVE

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode3D(camera)
        rl.DrawGrid(10, 1)
        rl.EndMode3D()
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
