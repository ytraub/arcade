function game_init()
    make_blocks()
    make_player()

    _update60 = game_update60
    _draw = game_draw
end

function game_update60()
    move_player()
    clear_full_rows()
end

function game_draw()
    cls(1)
    clip()

    rectfill(0, 0, 38, 127, 5)
    rectfill(87, 0, 127, 127, 5)
    rectfill(6, 4, 32, 12, 1)

    draw_points()

    draw_block(player.variant, player.rotation, player.x, player.y)
    draw_blocks()
end