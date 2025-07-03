package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Cube"

Cube :: struct {
    pos: rl.Vector3,
    size: rl.Vector3,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    camera := rl.Camera3D{}
    camera.position = {10, 10, 10}
    camera.target = {0, 0, 0}
    camera.up = {0, 1, 0}
    camera.fovy = 45
    camera.projection = rl.CameraProjection.PERSPECTIVE

    cube := Cube{}
    cube.pos = {0, 1, 0}
    cube.size = {2, 2, 2}
    i: f32 = 10
    j: f32 = 10

    for !rl.WindowShouldClose() {
        if rl.IsKeyDown(.LEFT) {
            i -= 0.05
        }

        if rl.IsKeyDown(.RIGHT) {
            i += 0.05
        }

        if rl.IsKeyDown(.UP) {
            cube.size.y += 0.05
            if cube.size.y > 7 do cube.size.y = 7
        }

        if rl.IsKeyDown(.DOWN) {
            cube.size.y -= 0.05
            if cube.size.y < 0.1 do cube.size.y = 0.1
        }

        camera.position.x = math.cos(i) * 10
        camera.position.z = math.sin(i) * 10

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode3D(camera)
        rl.DrawCubeV(cube.pos, cube.size, rl.BLUE)
        rl.DrawCubeWiresV(cube.pos, cube.size, rl.DARKBLUE)
        rl.EndMode3D()
        rl.EndDrawing()
    }

    rl.CloseWindow()
}