name = ""
coins = 0

function _init()
    serial(0x806, 0x9a00, 64)

    local text = ""

    for i=0,63 do
        local c = peek(0x9a00 + i)

        if c == 0 then
            break
        end

        text = text .. chr(c)
    end

    printh("received=[" .. text .. "]")

    local pos

    for i=1,#text do
        if sub(text, i, i) == ":" then
            pos = i
            break
        end
    end

    if pos then
        name = sub(text, 1, pos - 1)
        coins = sub(text, pos + 1) + 0
    end
    
    menu_init()
end

function menu_init()
    t = 0

    _update60 = menu_update60
    _draw = menu_draw
end

function menu_update60()
    t += 1

    if btnp(5) then
        game_init()
    end
end

function menu_draw()
    cls()
    draw_title()
end

function draw_title()
    cls(1)

    print_shadow("TETRIS", 48, 30, 7, 0, 2)
    draw_tetriminoes()

    print_shadow("press", 30, 90, 6, 0, 1)
    if (t \ 30) % 2 == 0 then
        print_shadow("❎", 52, 90, 6, 0, 1)
    end
    print_shadow("to start", 62, 90, 6, 0, 1)
end

function print_shadow(text, x, y, color, shadow_color, offset)
    print(text, x + offset, y + offset, shadow_color)
    print(text, x, y, color)
end

function draw_tetriminoes()
    local colors = { 8, 9, 10, 11, 12, 13, 14 }
    local x = 20
    local y = 60

    for i = 1, 7 do
        rectfill(x + (i - 1) * 12, y, x + (i - 1) * 12 + 8, y + 8, colors[i])
    end
end