function _init()
    serial(0x806, 0x9a00, 8)
    local text = ""
    for i=0, 7 do
        text = text .. chr(peek(0x9a00 + i))
    end

    local pos = data:find(":")

    if pos then
        name = sub(data, 1, pos - 1)
        coins = sub(data, pos + 1)
    end
end

function _update()
    if btnp(4) then
        start_spin()
    end

    if game_state == "idle" then
        if btnp(0) then
            bet = max(1, bet-1)
        end

        if btnp(1) then
            bet = min(20, bet+1)
        end
    end

    update_game()
end

function _draw()
    draw_ui()
end