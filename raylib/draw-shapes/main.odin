package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Draw Shapes"

TOOLBAR_ITEM_SIZE :: 20
TOOLBAR_GAP :: 2

Pixel :: struct {
    p: rl.Vector2,
}

Line :: struct {
   p1: rl.Vector2,
   p2: rl.Vector2,
   started: bool,
}

Rectangle :: struct {
    p1: rl.Vector2,
    p2: rl.Vector2,
    started: bool,
}

Shape :: union {
    Pixel,
    Line,
    Rectangle,
}

ToolbarAction :: enum {
    PIXEL,
    LINE,
    RECT,
}

ToolboxItem :: struct {
    rec: rl.Rectangle,
    action: ToolbarAction,
}

Toolbox :: struct {
    rec: rl.Rectangle,
    items: [3]ToolboxItem,
    selected: ToolbarAction
}

HistoryItem :: struct {
    shape: Shape,
    next: ^HistoryItem,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    toolbox: Toolbox
    init_toolbox(&toolbox)

    shape: Shape = Pixel{}
    history: ^HistoryItem
    draw_marker := false
    marker: rl.Vector2

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.U) && history != nil {
            tmp := history
            history = history.next
            free(tmp)
        }

        if rl.IsMouseButtonPressed(rl.MouseButton.LEFT) {
            if !check_toolbox(&toolbox, &shape) {
                switch &s in shape {
                    case Pixel:
                        s.p = rl.GetMousePosition()
                        hi := new(HistoryItem)
                        hi.shape = shape
                        hi.next = history
                        history = hi
                    case Line:
                        if s.started {
                            s.p2 = rl.GetMousePosition()
                            hi := new(HistoryItem)
                            hi.shape = shape
                            hi.next = history
                            history = hi
                            s.started = false
                            draw_marker = false
                        } else {
                            s.p1 = rl.GetMousePosition()
                            s.started = true
                            draw_marker = true
                            marker = s.p1
                        }
                    case Rectangle:
                        if s.started {
                            s.p2 = rl.GetMousePosition()
                            hi := new(HistoryItem)
                            hi.shape = shape
                            hi.next = history
                            history = hi
                            s.started = false
                            draw_marker = false
                        } else {
                            s.p1 = rl.GetMousePosition()
                            s.started = true
                            draw_marker = true
                            marker = s.p1
                        }
                }
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        draw_toolbar(toolbox)

        for hi := history; hi != nil; hi = hi.next {
            switch s in hi.shape {
                case Pixel:
                    rl.DrawPixelV(s.p, rl.RAYWHITE)
                case Line:
                    rl.DrawLineV(s.p1, s.p2, rl.RAYWHITE)
                case Rectangle:
                    x := i32(s.p1.x > s.p2.x ? s.p2.x : s.p1.x)
                    y := i32(s.p1.y > s.p2.y ? s.p2.y : s.p1.y)
                    w := i32(math.abs(s.p1.x - s.p2.x))
                    h := i32(math.abs(s.p1.y - s.p2.y))

                    rl.DrawRectangleLines(x, y, w, h, rl.RAYWHITE)
            }
        }

        if draw_marker {
            rl.DrawCircleV(marker, 10, rl.GREEN)
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

draw_toolbar :: proc(tb: Toolbox) {
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

init_toolbox :: proc(tb: ^Toolbox) {
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

check_toolbox :: proc(tb: ^Toolbox, shape: ^Shape) -> bool {
    mp := rl.GetMousePosition()
    for item in tb.items {
        rec := item.rec
        if mp.x > rec.x && mp.x < rec.x + rec.width {
            if mp.y > rec.y && mp.y < rec.y + rec.height {
                tb.selected = item.action

                switch tb.selected {
                    case .PIXEL:
                        shape^ = Pixel{}
                    case .LINE:
                        shape^ = Line{}
                    case .RECT:
                        shape^ = Rectangle{}
                }

                return true

            }
        }
    }

    return false
}