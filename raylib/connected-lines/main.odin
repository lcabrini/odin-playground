package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Connected Lines"


main :: proc() {
	rl.SetTraceLogLevel(.ERROR)
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WIDTH, HEIGHT, TITLE)
	target := rl.LoadRenderTexture(WIDTH, HEIGHT)
	rl.SetTargetFPS(30)

	endpoint_x := i32(0)
	endpoint_y := i32(0)
	line_drawn := false
	should_clear := true
	paused := false

	for !rl.WindowShouldClose() {
		if rl.IsKeyPressed(.P) do paused = !paused

		if !paused {
			if rl.IsKeyPressed(.C) do should_clear = true

			x1 := line_drawn ? endpoint_x : rl.GetRandomValue(0, WIDTH - 1)
			y1 := line_drawn ? endpoint_y : rl.GetRandomValue(0, HEIGHT - 1)
			x2 := rl.GetRandomValue(0, WIDTH - 1)
			y2 := rl.GetRandomValue(0, HEIGHT - 1)
			r := u8(rl.GetRandomValue(0, 255))
			g := u8(rl.GetRandomValue(0, 255))
			b := u8(rl.GetRandomValue(0, 255))
			line_drawn = true
			endpoint_x = x2
			endpoint_y = y2

			rl.BeginTextureMode(target)
			if should_clear {
				rl.ClearBackground(rl.BLACK)
				should_clear = false
			}

			rl.DrawLine(x1, y1, x2, y2, {r, g, b, 255})
			rl.EndTextureMode()
		}

		rl.BeginDrawing()
		rl.DrawTextureRec(target.texture, {0, 0, WIDTH, -HEIGHT}, {0, 0}, rl.WHITE)
		rl.EndDrawing()
	}

	rl.UnloadRenderTexture(target)
	rl.WindowShouldClose()
}
