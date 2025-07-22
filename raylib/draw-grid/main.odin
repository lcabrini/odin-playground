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

    delay := 0
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

    colors: []rl.Color = {
        rl.RED,
        rl.GREEN,
        rl.BLUE,
        rl.YELLOW,
        rl.ORANGE,
        rl.WHITE,
    }

    color_idx := 0

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        done := true
        for &line in lines {
            rl.DrawLineV(line.from, line.to, colors[color_idx])
            if line.to.x < line.final.x || line.to.y < line.final.y {
                line.to += line.inc
                done = false
                break
            }
        }

        if done {
            color_idx += 1
            if color_idx >= len(colors) do color_idx = 0
            for &line in lines {
                line.to = line.from
            }
        }
 
        rl.EndDrawing()
    }

    rl.CloseWindow()
}
