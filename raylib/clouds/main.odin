package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Clouds"

Cloud :: struct {
    texture: rl.Texture,
    pos: rl.Vector2,
    layer: i32,
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    cloud_textures: [8]rl.Texture
    cloud_textures[0] = rl.LoadTexture("../../resources/cloud1.png")
    cloud_textures[1] = rl.LoadTexture("../../resources/cloud2.png")
    cloud_textures[2] = rl.LoadTexture("../../resources/cloud3.png")
    cloud_textures[3] = rl.LoadTexture("../../resources/cloud4.png")
    cloud_textures[4] = rl.LoadTexture("../../resources/cloud5.png")
    cloud_textures[5] = rl.LoadTexture("../../resources/cloud6.png")
    cloud_textures[6] = rl.LoadTexture("../../resources/cloud7.png")
    cloud_textures[7] = rl.LoadTexture("../../resources/cloud8.png")

    clouds: [15]Cloud

    for &cloud in clouds {
        idx := rl.GetRandomValue(0, 7)
        cloud.texture = cloud_textures[idx]
        cloud.pos.x = f32(-cloud.texture.width - rl.GetRandomValue(1, 300))
        cloud.pos.y = f32(rl.GetRandomValue(0, 200))
        cloud.layer = rl.GetRandomValue(1, 10)
    }



    for !rl.WindowShouldClose() {
        for &cloud in clouds {
            cloud.pos.x += f32(cloud.layer) / 8
            if cloud.pos.x > WIDTH {
                idx := rl.GetRandomValue(0, 7)
                cloud.texture = cloud_textures[idx]
                cloud.pos.x = f32(-cloud.texture.width - rl.GetRandomValue(1, 300))
                cloud.pos.y = f32(rl.GetRandomValue(0, 200))
                cloud.layer = rl.GetRandomValue(1, 10)
            }
        }

        rl.BeginDrawing()
        rl.ClearBackground(rl.BLUE)
        rl.DrawRectangle(0, HEIGHT-50, WIDTH, 50, rl.GREEN)

        for l: i32 = 1; l < 10; l += 1 {
            for cloud in clouds {
                if cloud.layer != l do continue
                tint := u8(cloud.layer * 10 + 150)
                rl.DrawTextureV(cloud.texture, cloud.pos, {tint, tint, tint, 255})
            }
        }

        rl.EndDrawing()
    }

    for texture in cloud_textures {
        rl.UnloadTexture(texture)
    }
    rl.CloseWindow()
}