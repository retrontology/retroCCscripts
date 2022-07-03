function main()
    local refills = tonumber(arg[1])
    local dir = string.lower(arg[2])
    local place_func = nil
    if dir == 'up' then
        place_func = turtle.placeUp
    elseif dir == 'down' then
        place_func = turtle.placeDown
    else
        place_func = turtle.place
    end
    for i=1,refills do
        place_func()
        turtle.refuel()
    end
end

main()