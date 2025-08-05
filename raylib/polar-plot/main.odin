package main

import "core:math"
import "core:math/rand"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Cartesian to Polar"
MIDX :: WIDTH / 2
MIDY :: HEIGHT / 2

main :: proc() {
	rl.SetTraceLogLevel(.ERROR)
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WIDTH, HEIGHT, TITLE)
	rl.SetTargetFPS(60)
	target := rl.LoadRenderTexture(WIDTH, HEIGHT)

	should_clear := true
	paused := false

	for !rl.WindowShouldClose() {
		if rl.IsKeyPressed(.P) do paused = !paused

		if !paused {
			if rl.IsKeyPressed(.C) do should_clear = true

			rl.BeginTextureMode(target)

			if should_clear {
				rl.ClearBackground(rl.BLACK)
				should_clear = false
			}

			for i in 0 ..< 50 {
				l := rand.float32() * 600 - 300
				a := rand.float32() * 360 * rl.DEG2RAD
				x := MIDX + l * math.cos(a)
				y := MIDY + l * math.sin(a)
				r := u8(rl.GetRandomValue(100, 255))
				g := u8(rl.GetRandomValue(100, 255))
				b := u8(rl.GetRandomValue(100, 255))
				rl.DrawPixelV({x, y}, {r, g, b, 255})
			}

			rl.EndTextureMode()
		}

		rl.BeginDrawing()
		rl.DrawTextureRec(target.texture, {0, 0, WIDTH, -HEIGHT}, {0, 0}, rl.WHITE)
		rl.EndDrawing()
	}

	rl.CloseWindow()
}
