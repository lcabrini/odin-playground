package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Draw Shapes"

TOOLBAR_ITEM_SIZE :: 20
TOOLBAR_GAP :: 2

ToolbarAction :: enum {
    PIXEL,
    LINE,
    RECT,
}

ToolboxItem :: struct {
    rec: rl.Rectangle,
    action: ToolbarAction,
}

Toolbar :: struct {
    rec: rl.Rectangle,
    items: [3]ToolboxItem,
    selected: ToolbarAction
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    toolbar: Toolbar
    init_toolbar(&toolbar)

    for !rl.WindowShouldClose() {
        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            mp := rl.GetMousePosition()
            for item in toolbar.items {
                rec := item.rec
                if mp.x > rec.x && mp.x < rec.x + rec.width {
                    if mp.y > rec.y && mp.y < rec.y + rec.height {
                        toolbar.selected = item.action
                        break
                    }
                }
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        draw_toolbar(toolbar)
        rl.EndDrawing()
    }
}

draw_toolbar :: proc(tb: Toolbar) {
    rl.DrawRectangleRec(tb.rec, rl.BLUE)

    for item in tb.items {
        color := tb.selected == item.action ? rl.GRAY : rl.RAYWHITE
        rl.DrawRectangleRec(item.rec, color)

        switch item.action {
            case .PIXEL:
                x := i32(item.rec.x + item.rec.width / 2)
                y := i32(item.rec.y + item.rec.height / 2)
                rl.DrawPixel(x, y, rl.BLACK)
            case .LINE:
                x1 := i32(item.rec.x + TOOLBAR_GAP)
                y1 := i32(item.rec.y + TOOLBAR_GAP)
                x2 := i32(item.rec.x + item.rec.width- TOOLBAR_GAP*2)
                y2 := i32(item.rec.y + item.rec.height - TOOLBAR_GAP*2)
                rl.DrawLine(x1, y1, x2, y2, rl.BLACK)
            case .RECT:
                x := i32(item.rec.x + TOOLBAR_GAP)
                y := i32(item.rec.y + TOOLBAR_GAP)
                w := i32(item.rec.height - TOOLBAR_GAP*2)
                h := i32(item.rec.height - TOOLBAR_GAP*2)
                rl.DrawRectangleLines(x, y, w, h, rl.BLACK)
        }
    }
}

init_toolbar :: proc(tb: ^Toolbar) {
    tb.rec.x = WIDTH - (TOOLBAR_ITEM_SIZE + TOOLBAR_GAP*2)
    tb.rec.y = 0
    tb.rec.width = TOOLBAR_ITEM_SIZE + TOOLBAR_GAP * 2
    tb.rec.height = HEIGHT
    tb.selected = ToolbarAction.PIXEL

    ypos: f32 = 2
    for action, i in ToolbarAction {
        tb.items[i].rec.x = tb.rec.x + TOOLBAR_GAP
        tb.items[i].rec.y = ypos
        tb.items[i].rec.width = TOOLBAR_ITEM_SIZE
        tb.items[i].rec.height = TOOLBAR_ITEM_SIZE
        tb.items[i].action = action

        ypos += TOOLBAR_ITEM_SIZE + TOOLBAR_GAP
    }
}