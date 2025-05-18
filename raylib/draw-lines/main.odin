package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Draw Lines"

Line :: struct {
    start_pos: rl.Vector2,
    end_pos: rl.Vector2,
    started: bool,
}

HistoryItem :: struct {
    line: Line,
    next: ^HistoryItem,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetExitKey(.Q)
    rl.SetTargetFPS(60)

    line: Line
    history: ^HistoryItem

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.U) && history != nil {
            tmp := history
            history = history.next
            free(tmp)
        }

        if rl.IsKeyPressed(.ESCAPE) && line.started {
            line.started = false
        }

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            if line.started {
                line.end_pos = rl.GetMousePosition()
                hi := new(HistoryItem)
                hi.line = line
                hi.next = history
                history = hi
                line.started = false
            } else {
                line.start_pos = rl.GetMousePosition()
                line.started = true
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        if line.started {
            rl.DrawCircleV(line.start_pos, 10, rl.GREEN)
        }

        for hi := history; hi != nil; hi = hi.next {
            rl.DrawLineV(hi.line.start_pos, hi.line.end_pos, rl.RAYWHITE)
        }

        rl.EndDrawing()
    }

    for history != nil {
        next := history.next
        free(history)
        history = next
    }

    rl.CloseWindow()
}