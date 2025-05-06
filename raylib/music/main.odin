package main

import "core:fmt"
import rl "vendor:raylib"

/*
    Based on a program I wrote in C, using SDL.
    Inspired by the AmigaBASIC "Music" demo.
*/

WB_RED :: 0
WB_GREEN :: 85
WB_BLUE :: 169
WB_BACKGROUND :: rl.Color{WB_RED, WB_GREEN, WB_BLUE, 255}

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Music"

LINES_PER_QUADRANT :: 30
LINE_STEP :: 10
LINE_COUNT :: LINES_PER_QUADRANT * 2

LEFT :: 0
TOP :: 0
RIGHT :: WIDTH - 1
BOTTOM :: HEIGHT - 1

Line :: struct {
    x1: int,
    y1: int,
    x2: int,
    y2: int,
    next: ^Line,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(30)

    head := init_lines()
    current := head

    rl.InitAudioDevice()
    music := rl.LoadMusicStream("jesu-joy-of-mans-desiring.mp3")
    rl.PlayMusicStream(music)

    paused := false
    line_count := 1
    time_played: f32 = 0.0

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            paused = !paused
            if paused {
                rl.PauseMusicStream(music)
            } else {
                rl.ResumeMusicStream(music)
            }
        }

        if rl.IsKeyPressed(.R) && !paused {
            rl.StopMusicStream(music)
            rl.PlayMusicStream(music)
            current = head
            line_count = 1
        }

        rl.UpdateMusicStream(music)
        time_played = rl.GetMusicTimePlayed(music) / rl.GetMusicTimeLength(music)
        if time_played > 1.0 do time_played = 1.0

        rl.BeginDrawing()
        rl.ClearBackground(WB_BACKGROUND)

        red := u8(WB_RED)
        green := u8(WB_GREEN)
        blue := u8(WB_BLUE)

        rs := (255 - 0) / line_count
        gs := (255 - 85) / line_count
        bs := (255 - 169) / line_count

        line := current
        for i in 0..<line_count {
            red += u8(rs)
            green += u8(gs)
            blue += u8(bs)
            rl.DrawLine(i32(line.x1), i32(line.y1), i32(line.x2), i32(line.y2), {red, green, blue, 255})
            line = line.next
        }

        rl.EndDrawing()

        if !paused && line_count == LINE_COUNT do current = current.next
        if !paused && line_count < LINE_COUNT do line_count += 1
    }

    rl.UnloadAudioStream(music)
    rl.CloseAudioDevice()
    rl.CloseWindow()

    free_lines(head)
}

init_lines :: proc() -> ^Line {
    head, current, tail: ^Line

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = LEFT
        current.y1 = LINE_STEP * (LINES_PER_QUADRANT - q)
        current.x2 = LINE_STEP * q
        current.y2 = TOP
        if (head == nil) do head = current
        if (tail != nil) do tail.next = current
        tail = current
    }

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = RIGHT - LINE_STEP * (LINES_PER_QUADRANT - q)
        current.y1 = TOP
        current.x2 = RIGHT
        current.y2 = LINE_STEP * q
        tail.next = current
        tail = current
    }

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = RIGHT
        current.y1 = BOTTOM - LINE_STEP * (LINES_PER_QUADRANT - q)
        current.x2 = RIGHT - LINE_STEP * q
        current.y2 = BOTTOM
        tail.next = current
        tail = current
    }

    for q in 0..<LINES_PER_QUADRANT {
        current = new(Line)
        current.x1 = LEFT + LINE_STEP * (LINES_PER_QUADRANT - q)
        current.y1 = BOTTOM
        current.x2 = LEFT
        current.y2 = BOTTOM - LINE_STEP * q
        tail.next = current
        tail = current
    }

    tail.next = head
    return head
}

free_lines :: proc(head: ^Line) {
    current := head

    for {
        previous := current
        current = current.next
        previous.next = nil
        if current == nil do break
        if previous != nil do free(previous)
    }
}