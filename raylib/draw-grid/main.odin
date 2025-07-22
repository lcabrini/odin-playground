package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Draw Grid"
SPACING :: 30
SPEED :: 50

Line :: struct {
    from: rl.Vector2,
    to: rl.Vector2,
    final: rl.Vector2,
    inc: rl.Vector2,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    lines: [dynamic]Line
    for y: f32 = 0; y < HEIGHT; y += SPACING {
        line := Line{}
        line.from = {0, y}
        line.to = {0, y}
        line.final = {WIDTH, y}
        line.inc = {SPEED, 0}
        append(&lines, line)
    }

    for x: f32 = 0; x < WIDTH; x += SPACING {
        line := Line{}
        line.from = {x, 0}
        line.to = {x, 0}
        line.final = {x, HEIGHT}
        line.inc = {0, SPEED}
        append(&lines, line)
    }

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for &line in lines {
            rl.DrawLineV(line.from, line.to, rl.GREEN)
            if line.to.x < line.final.x || line.to.y < line.final.y {
                line.to += line.inc
                break
            }
        }
 
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
