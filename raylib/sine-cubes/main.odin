package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Sine Cubes"

Cube :: struct {
    pos: rl.Vector3,
    size: rl.Vector3,
    color: rl.Color,
    wire_color: rl.Color,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    camera := rl.Camera3D{}
    camera.position = {50, 50, 50}
    camera.target = {25, 0, 0}
    camera.up = {0, 1, 0}
    camera.fovy = 45
    camera.projection = rl.CameraProjection.PERSPECTIVE

    cubes: [50]Cube
    for i := 0; i < 50; i += 1 {
        cubes[i].pos.x = f32(i)
        cubes[i].pos.z = 0
        cubes[i].size = {1, 1, 1}
        r := u8(rl.GetRandomValue(100, 255))
        g := u8(rl.GetRandomValue(100, 255))
        b := u8(rl.GetRandomValue(100, 255))
        cubes[i].color = {r, g, b, 255}
        cubes[i].wire_color = {r-50, g-50, b-50, 255}
    }

    for !rl.WindowShouldClose() {
        t := f32(rl.GetTime())
        camera.position.x = math.cos(t*0.7) * 50
        camera.position.z = math.sin(t*0.7) * 50

        for i := 0; i < 50; i += 1 {
            cubes[i].pos.y += math.sin(t+f32(i)*0.3) / 5
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        rl.BeginMode3D(camera)

        for cube in cubes {
            rl.DrawCubeV(cube.pos, cube.size, cube.color)
            rl.DrawCubeWiresV(cube.pos, cube.size, cube.wire_color)
        }

        rl.EndMode3D()
        rl.EndDrawing()
    }
}