package main

import "core:math"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Random Circles"

main :: proc() {
	rl.SetTraceLogLevel(.ERROR)
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WIDTH, HEIGHT, TITLE)
	rl.SetTargetFPS(60)

	target := rl.LoadRenderTexture(WIDTH, HEIGHT)
	paused := false
	clear := true
	fill := true
	use_r := true
	use_g := true
	use_b := true

	for !rl.WindowShouldClose() {
		if rl.IsKeyPressed(.P) {
			paused = !paused
		}

		if !paused {
			if rl.IsKeyPressed(.C) {
				clear = true
			}

			if rl.IsKeyPressed(.F) {
				fill = !fill
			}

			if rl.IsKeyPressed(.R) {
				use_r = !use_r
			}

			if rl.IsKeyPressed(.G) {
				use_g = !use_g
			}

			if rl.IsKeyPressed(.B) {
				use_b = !use_b
			}

			rl.BeginTextureMode(target)
			if clear {
				rl.ClearBackground(rl.BLACK)
				clear = false
			}

			x := rl.GetRandomValue(1, WIDTH - 2)
			y := rl.GetRandomValue(1, HEIGHT - 2)
			max_radius := x
			if WIDTH - x < x do max_radius = WIDTH - x
			if y < max_radius do max_radius = y
			if HEIGHT - y < max_radius do max_radius = HEIGHT - y
			radius := f32(rl.GetRandomValue(1, max_radius))
			r := use_r ? u8(rl.GetRandomValue(1, 255)) : 0
			g := use_g ? u8(rl.GetRandomValue(1, 255)) : 0
			b := use_b ? u8(rl.GetRandomValue(1, 255)) : 0

			if fill {
				rl.DrawCircle(x, y, radius, {r, g, b, 255})
			} else {
				rl.DrawCircleLines(x, y, radius, {r, g, b, 255})
			}
		}
		rl.EndTextureMode()

		rl.BeginDrawing()
		rl.DrawTextureRec(target.texture, {0, 0, WIDTH, -HEIGHT}, {0, 0}, rl.WHITE)
		rl.EndDrawing()
	}

	rl.UnloadRenderTexture(target)
	rl.CloseWindow()
}
