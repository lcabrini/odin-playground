package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Toggle"

TOGGLE_WIDTH :: 300
TOGGLE_HEIGHT :: 600
TOGGLE_X :: WIDTH / 2 - TOGGLE_WIDTH / 2
TOGGLE_Y :: HEIGHT / 2 - TOGGLE_HEIGHT / 2
GAP :: 10
BUTTON_HEIGHT :: TOGGLE_HEIGHT / 2
TOGGLE_SPEED :: 10

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    switching := false
    dir: i32 = -TOGGLE_SPEED
    y: i32 = TOGGLE_Y + GAP

    for !rl.WindowShouldClose() {
        on_toggle := is_mouse_on_switch()

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) && on_toggle {
            switching = true
            dir *= -1
        }

        color := rl.RAYWHITE
        if on_toggle {
            color = rl.YELLOW
        }

        if switching {
            y += dir
            if y <= TOGGLE_Y + GAP || y >= TOGGLE_Y + TOGGLE_HEIGHT - BUTTON_HEIGHT - GAP {
                switching = false
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        rl.DrawRectangleLines(TOGGLE_X,TOGGLE_Y, TOGGLE_WIDTH, TOGGLE_HEIGHT, color)
        rl.DrawRectangle(TOGGLE_X + GAP, y, TOGGLE_WIDTH - GAP*2, BUTTON_HEIGHT, color)

        rl.EndDrawing()
    }

    rl.CloseWindow()
}

is_mouse_on_switch :: proc() -> bool {
    mpos := rl.GetMousePosition()
    if mpos.x < TOGGLE_X || mpos.x > TOGGLE_X + TOGGLE_WIDTH {
        return false
    }

    if mpos.y < TOGGLE_Y || mpos.y > TOGGLE_Y + TOGGLE_HEIGHT {
        return false
    }

    return true
}
