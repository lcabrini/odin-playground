package main

import "core:fmt"
import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Draw Grid"
SPACING :: 30
SPEED :: 10
DELAY :: 200

Line :: struct {
	from:  rl.Vector2,
	to:    rl.Vector2,
	final: rl.Vector2,
	inc:   rl.Vector2,
}

main :: proc() {
	rl.SetTraceLogLevel(.ERROR)
	rl.SetConfigFlags({.VSYNC_HINT})
	rl.InitWindow(WIDTH, HEIGHT, TITLE)
	rl.SetTargetFPS(60)

	delay: f32 = 0
	lines: [dynamic]Line
	for y: f32 = 0; y < HEIGHT; y += SPACING {
		line := Line{}
		line.from = {0, y}
		line.to = {delay, y}
		line.final = {WIDTH, y}
		line.inc = {SPEED, 0}
		append(&lines, line)
		delay -= DELAY
	}

	for x: f32 = 0; x < WIDTH; x += SPACING {
		line := Line{}
		line.from = {x, 0}
		line.to = {x, delay}
		line.final = {x, HEIGHT}
		line.inc = {0, SPEED}
		append(&lines, line)
		delay -= DELAY
	}

	colors: []rl.Color = {rl.RED, rl.GREEN, rl.BLUE, rl.YELLOW, rl.ORANGE, rl.WHITE}

	color_idx := 0
	paused := false
	image := rl.LoadImageFromScreen()
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)
	done: bool

	for !rl.WindowShouldClose() {
		if rl.IsKeyPressed(.P) {
			paused = !paused
		}

		if rl.IsKeyPressed(.R) {
			delay: f32 = 0
			color_idx = 0
			if color_idx >= len(colors) do color_idx = 0
			for &line in lines {
				line.to = line.inc.x > 0 ? {delay, line.to.y} : {line.to.x, delay}
				delay -= DELAY
			}

			rl.UnloadTexture(texture)
			image := rl.LoadImageFromScreen()
			rl.ImageClearBackground(&image, rl.BLACK)
			texture = rl.LoadTextureFromImage(image)
			rl.UnloadImage(image)
		}

		if rl.IsKeyPressed(.C) {
			rl.UnloadTexture(texture)
			image := rl.LoadImageFromScreen()
			rl.ImageClearBackground(&image, rl.BLACK)
			texture = rl.LoadTextureFromImage(image)
			rl.UnloadImage(image)

		}

		done := false
		if !paused {
			done = true
			for &line in lines {
				if line.to.x < line.final.x || line.to.y < line.final.y {
					done = false
					line.to += line.inc
				}
			}
		}

		rl.BeginDrawing()
		rl.DrawTexture(texture, 0, 0, rl.WHITE)

		for line in lines {
			if line.to.x > 0 && line.to.y > 0 {
				rl.DrawLineV(line.from, line.to, colors[color_idx])
				rl.DrawCircleV(line.to, 2, rl.RAYWHITE)
			}

		}

		if done {
			delay: f32 = 0
			color_idx += 1
			if color_idx >= len(colors) do color_idx = 0
			for &line in lines {
				line.to = line.inc.x > 0 ? {delay, line.to.y} : {line.to.x, delay}
				delay -= DELAY
			}
		}

		rl.EndDrawing()

		if done {
			rl.UnloadTexture(texture)
			image := rl.LoadImageFromScreen()
			texture = rl.LoadTextureFromImage(image)
			rl.UnloadImage(image)

		}
	}

	rl.UnloadTexture(texture)
	rl.CloseWindow()
}
