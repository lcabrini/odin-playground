package main

import rl "vendor:raylib"

WIDTH :: 1024
HEIGHT :: 768
TITLE :: "Rocks and Diamonds"
TILE_SIZE :: 32
MAP_WIDTH :: 64
MAP_HEIGHT :: 32

TileType :: enum {
    EMPTY,
    SOIL,
    BORDER,
    ROCK,
    PLAYER,
}

Tile :: struct {
    type: TileType,
    spritesheet: ^rl.Texture,
    sheet_x: i32,
    sheet_y: i32,
}

Map :: struct {
    tiles: [MAP_HEIGHT][MAP_WIDTH]Tile
}

main :: proc() {
    rl.SetConfigFlags({.VSYNC_HINT})
    rl.InitWindow(WIDTH, HEIGHT, TITLE)
    rl.SetTargetFPS(60)

    spritesheet_1 := rl.LoadTexture("../../resources/RocksBD.png")
    spritesheet_2 := rl.LoadTexture("../../resources/RocksSP.png")
    spritesheet_3 := rl.LoadTexture("../../resources/RocksHeroes.png")
    spritesheet_4 := rl.LoadTexture("../../resources/RocksMore.png")

    soil := Tile{}
    soil.type = .SOIL
    soil.spritesheet = &spritesheet_4
    soil.sheet_x = 0
    soil.sheet_y = 2 

    border := Tile{}
    border.type = .BORDER
    border.spritesheet = &spritesheet_2
    border.sheet_x = 0
    border.sheet_y = 5

    rock := Tile{}
    rock.type = .ROCK
    rock.spritesheet = &spritesheet_1
    rock.sheet_x = 11
    rock.sheet_y = 4

    game_map := Map{}
    for y in 0..<MAP_HEIGHT {
        for x in 0..<MAP_WIDTH {
            if y == 0 || y == MAP_HEIGHT-1 {
                game_map.tiles[y][x] = border
            } else if x == 0 || x == MAP_WIDTH-1 {
                game_map.tiles[y][x] = border
            } else {
                game_map.tiles[y][x] = soil
            }
        }
    }

    for i in 0..<30 {
        x := rl.GetRandomValue(1, MAP_WIDTH-2)
        y := rl.GetRandomValue(1, MAP_HEIGHT-2)
        game_map.tiles[y][x] = rock
    }

    for !rl.WindowShouldClose() {
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)

        for y in 0..<MAP_HEIGHT {
            for x in 0..<MAP_WIDTH {
                tile := game_map.tiles[y][x]
                src := rl.Rectangle{f32(tile.sheet_x*TILE_SIZE), f32(tile.sheet_y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
                dest := rl.Rectangle{f32(x*TILE_SIZE), f32(y*TILE_SIZE), TILE_SIZE, TILE_SIZE}
                rl.DrawTexturePro(tile.spritesheet^, src, dest, {0, 0}, 0, rl.WHITE)
            }
        }
        rl.EndDrawing()
    }

    rl.UnloadTexture(spritesheet_1)
    rl.UnloadTexture(spritesheet_2)
    rl.UnloadTexture(spritesheet_3)
    rl.CloseWindow()
}
