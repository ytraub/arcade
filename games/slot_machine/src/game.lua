coins = 100
bet = 5

reels = {
    new_reel(),
    new_reel(),
    new_reel()
}

game_state = "idle"

function start_spin()
    if game_state != "idle" then
        return
    end

    if coins < bet then
        return
    end

    coins -= bet

    for reel in all(reels) do
        spin_reel(reel)
    end

    game_state = "spinning"
end

function check_win()
    local a = reels[1].symbol
    local b = reels[2].symbol
    local c = reels[3].symbol

    if a == b and b == c then
        return bet * 10
    end

    if a == b or b == c or a == c then
        return bet * 2
    end

    return 0
end

function update_game()
    local finished = true

    for reel in all(reels) do
        update_reel(reel)

        if reel.spinning then
            finished = false
        end
    end

    if game_state == "spinning" and finished then
        local win = check_win()

        coins += win

        game_state = "idle"
    end

    local output = "pidor:" .. coins
    printh(output, "receive.txt", true)
end