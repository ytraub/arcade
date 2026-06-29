function _init()
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