package main

import "core:fmt"
import "core:math"
import rl "vendor:raylib"

/*
   Adapted from the plasma effect on https://seancode.com/demofx/
*/

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Plasma"
MIDX :: WIDTH/2
MIDY :: HEIGHT/2

FONT_SIZE :: 120

ColorPresets :: enum {
    RG,
    RB,
    GR,
    GB,
    BR,
    BG,
}

OverlayType :: enum {
    NONE,
    TEXT,
    CIRCLE,
    TRIANGLE,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)
    
    font := rl.LoadFontEx("../../resources/Inter-ExtraBold.ttf", FONT_SIZE, nil, 0)
    image := rl.LoadImageFromScreen()
    
    pause := false
    overlay_type: OverlayType = .NONE
    colors: ColorPresets = .BG
    r, g, b: u8
    overlay: rl.Texture
    t: f32 = 0

    for !rl.WindowShouldClose() {
        if rl.IsKeyPressed(.P) {
            pause = !pause
        }

        if rl.IsKeyPressed(.S) {
            rl.TakeScreenshot("screenshot.png")
        }

        if !pause {
            t += 0.05

            if rl.IsKeyPressed(.O) {
                rl.UnloadTexture(overlay)
                switch overlay_type {
                case .NONE:
                    overlay_type = .TEXT
                    overlay_image := rl.LoadImageFromScreen()
                    rl.ImageClearBackground(&overlay_image, rl.BLACK)
                    msg: cstring = "Plasma Effect"
                    ts := rl.MeasureTextEx(font, msg, FONT_SIZE, 1)
                    tp := rl.Vector2{MIDX - ts.x/2, MIDY - ts.y/2}
                    rl.ImageDrawTextEx(&overlay_image, font, msg, tp, FONT_SIZE, 1, rl.WHITE)
                    overlay = rl.LoadTextureFromImage(overlay_image)
                    rl.UnloadImage(overlay_image)
                case .TEXT:
                    overlay_type = .CIRCLE
                    overlay_image := rl.LoadImageFromScreen()
                    rl.ImageClearBackground(&overlay_image, rl.BLACK)
                    rl.ImageDrawCircle(&overlay_image, MIDX, MIDY, 300, rl.WHITE)
                    overlay = rl.LoadTextureFromImage(overlay_image)
                    rl.UnloadImage(overlay_image)
                case .CIRCLE:
                    overlay_type = .TRIANGLE
                    overlay_image := rl.LoadImageFromScreen()
                    rl.ImageClearBackground(&overlay_image, rl.BLACK)
                    v1 := rl.Vector2{MIDX, 100}
                    v2 := rl.Vector2{100, HEIGHT-100}
                    v3 := rl.Vector2{WIDTH-100, HEIGHT-100}
                    rl.ImageDrawTriangle(&overlay_image, v1, v2, v3, rl.WHITE)
                    overlay = rl.LoadTextureFromImage(overlay_image)
                    rl.UnloadImage(overlay_image)
                case .TRIANGLE:
                    overlay_type = .NONE
                }
            }

            if rl.IsKeyPressed(.C) {
                switch colors {
                case .RG:
                    colors = .RB
                case .RB:
                    colors = .GR
                case .GR:
                    colors = .GB
                case .GB:
                    colors = .BR
                case .BR:
                    colors = .BG
                case .BG:
                    colors = .RG
                }
            }
                   
            for y: i32 = 0; y < HEIGHT; y += 1 {
                dy := f32(y) / HEIGHT - 0.5
                for x: i32 = 0; x < WIDTH; x += 1 {
                    dx := f32(x) / WIDTH - 0.5
                    v := math.sin(dx * 10 + t)
                    cx := dx + 0.5 * math.sin(t/5)
                    cy := dy + 0.5 * math.cos(t/3)
                    v += math.sin(math.sqrt(50 * (cx*cx + cy*cy) + 1 + t))
                    v += math.cos(math.sqrt(dx*dx + dy*dy) - t)

                    switch colors {
                    case .RG:
                        r = u8(math.sin(v*math.PI) * 255)
                        g = u8(math.cos(v*math.PI) * 255)
                        b = 0
                    case .RB:
                        r = u8(math.sin(v*math.PI) * 255)
                        g = 0
                        b = u8(math.cos(v*math.PI) * 255)
                    case .GR:
                        r = u8(math.cos(v*math.PI) * 255)
                        g = u8(math.sin(v*math.PI) * 255)
                        b = 0
                    case .GB:
                        r = 0
                        g = u8(math.sin(v*math.PI) * 255)
                        b = u8(math.cos(v*math.PI) * 255)
                    case .BR:
                        r = u8(math.cos(v*math.PI) * 255)
                        g = 0
                        b = u8(math.sin(v*math.PI) * 255)
                    case .BG:
                        r = 0
                        g = u8(math.cos(v*math.PI) * 255)
                        b = u8(math.sin(v*math.PI) * 255)
                    }

                    rl.ImageDrawPixel(&image, x, y, {r, g, b, 255})
                }
            }
        }

        texture := rl.LoadTextureFromImage(image)
        rl.BeginDrawing()
        rl.DrawTexture(texture, 0, 0, rl.WHITE)

        if overlay_type != .NONE {
            rl.BeginBlendMode(rl.BlendMode.MULTIPLIED)
            rl.DrawTexture(overlay, 0, 0, rl.WHITE)
            rl.EndBlendMode()
        }

        rl.EndDrawing()
        rl.UnloadTexture(texture)
    }

    rl.UnloadFont(font)
    rl.UnloadTexture(overlay)
    rl.UnloadImage(image)
    rl.CloseWindow()
}
