FUEL = "minecraft:lava"

function main()
    local refills = tonumber(arg[1])
    local dir = arg[2]
    if dir ~= nil then
        dir = string.lower(arg[2])
    end
    local place_func = turtle.place
    local inspect_func = turtle.inspect
    if dir == 'up' then
        place_func = turtle.placeUp
        inspect_func = turtle.inspectUp
    elseif dir == 'down' then
        place_func = turtle.placeDown
        inspect_func = turtle.inspectDown
    end
    for i=1,refills do
        local has_block, data = inspect_func()
        while not has_block or data.name ~= FUEL do
            sleep(0.05)
            has_block, data = inspect_func()
        end
        place_func()
        turtle.refuel()
        print('Current fuel: ' .. turtle.getFuelLevel())
    end
end

main()