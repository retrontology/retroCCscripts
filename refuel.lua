FUEL = "minecraft:lava"
BUCKET = "minecraft:bucket"
BUCKET_LAVA = "minecraft:lava_bucket"

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
    turtle.select(1)
    local details = turtle.getItemDetail()
    if details == nil or not (details.name == BUCKET or details.name == BUCKET_LAVA) then
        error('You must put an empty bucket in the first slot to run this program!')
    end
    for i=1,refills do
        while details.name == BUCKET and details.name ~= BUCKET_LAVA do
            sleep(0.05)
            place_func()
            details = turtle.getItemDetail()
        end
        if not turtle.refuel() then
            error('Could not refuel!')
        end
        details = turtle.getItemDetail()
        print('Current fuel: ' .. turtle.getFuelLevel())
    end
end

main()