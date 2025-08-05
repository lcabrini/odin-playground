package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Conway's Game of Life"
MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

Cell :: struct {
	alive: bool,
}

main :: proc() {
	rl.SetTraceLogLevel(.ERROR)
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WIDTH, HEIGHT, TITLE)
	rl.SetTargetFPS(60)

	cells := make([][]Cell, HEIGHT)
	for y in 0 ..< HEIGHT {
		cells[y] = make([]Cell, WIDTH)
	}

	for i in 0 ..< 5000 {
		x := rl.GetRandomValue(MIDX - 200, MIDX + 200)
		y := rl.GetRandomValue(MIDY - 200, MIDY + 200)
		cells[y][x].alive = true
	}

	for !rl.WindowShouldClose() {
		tmp := make([][]Cell, HEIGHT)
		for y in 0 ..< HEIGHT {
			tmp[y] = make([]Cell, WIDTH)
		}

		for y in 0 ..< HEIGHT do for x in 0 ..< WIDTH {
			tmp[y][x] = cells[y][x]
		}

		for y in 0 ..< HEIGHT do for x in 0 ..< WIDTH {
			alive_count := 0
			if y > 0 && x > 0 && cells[y - 1][x - 1].alive do alive_count += 1
			if y > 0 && cells[y - 1][x].alive do alive_count += 1
			if y > 0 && x < WIDTH - 1 && cells[y - 1][x + 1].alive do alive_count += 1
			if x > 0 && cells[y][x - 1].alive do alive_count += 1
			if x < WIDTH - 1 && cells[y][x + 1].alive do alive_count += 1
			if y < HEIGHT - 1 && x > 0 && cells[y + 1][x - 1].alive do alive_count += 1
			if y < HEIGHT - 1 && cells[y + 1][x].alive do alive_count += 1
			if y < HEIGHT - 1 && x < WIDTH - 1 && cells[y + 1][x + 1].alive do alive_count += 1

			if cells[y][x].alive {
				tmp[y][x].alive = alive_count < 2 || alive_count > 3 ? false : true
			} else {
				tmp[y][x].alive = alive_count == 3 ? true : false
			}
		}

		for y in 0 ..< HEIGHT do for x in 0 ..< WIDTH {
			cells[y][x] = tmp[y][x]
		}

		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		for y in 0 ..< i32(HEIGHT) {
			for x in 0 ..< i32(WIDTH) {
				if cells[y][x].alive do rl.DrawPixel(x, y, rl.WHITE)
			}
		}
		rl.EndDrawing()
	}

	rl.CloseWindow()
	for y in 0 ..< HEIGHT do delete(cells[y])
	delete(cells)
}
