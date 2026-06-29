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