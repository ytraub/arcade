function pad_number(n, digits)
    local s = tostr(n)
    while #s < digits do
        s = "0" .. s
    end
    return s
end
