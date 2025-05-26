package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Cell Selector"

CELL_WIDTH :: WIDTH / 20
CELL_HEIGHT :: HEIGHT / 15

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    cells: [20][10]bool

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            mp := rl.GetMousePosition()
            x := i32(mp.x) / CELL_WIDTH
            y := i32(mp.y) / CELL_HEIGHT
            cells[y][x] = !cells[y][x]
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for y: i32 = 0; y < HEIGHT; y += CELL_HEIGHT {
            rl.DrawLine(0, y, WIDTH, y, rl.GREEN)
        }

        for x: i32 = 0; x < WIDTH; x += CELL_WIDTH {
            rl.DrawLine(x, 0, x, HEIGHT, rl.GREEN)
        }

        for y: i32 = 0; y < len(cells); y += 1 {
            for x: i32 = 0; x < len(cells[y]); x += 1 {
                if cells[y][x] == true {
                    l := x * CELL_WIDTH + 1
                    t := y * CELL_HEIGHT + 1
                    w: i32 = CELL_WIDTH - 2
                    h: i32 = CELL_HEIGHT - 2
                    rl.DrawRectangle(l, t, w, h, rl.GRAY)
                }
            }
        }

        rl.EndDrawing()
    }

    rl.CloseWindow()
}