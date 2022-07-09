require "retroturtle"

SEA_LEVEL = 62
FUEL = 'minecraft:coal'

FUEL_CHEST = {
    X=0,
    Y=0,
    Z=0
}

SAND_CHEST = {
    X=0,
    Y=0,
    Z=0
}

MONUMENT_NW_CORNER = {
    X=0,
    Z=0
}

function main()
    sync_direction()
    drain_monument(MONUMENT_NW_CORNER.X, MONUMENT_NW_CORNER.Z)
end

function drain_monument(x, z)
    for i=0,59 do
        for j=0,59 do
            go_directly_to(x+i, SEA_LEVEL + 1, z+j)
            fill_sand()
        end
    end
end

function fill_sand()
    local index = find_item('minecraft:sand')
    if index == nil then
        refill_sand()
        index = find_item('minecraft:sand')
    end
    turtle.select(index)
    local has_block, data = turtle.inspectDown()
    while not has_block or data.name == 'minecraft:water' do
        if turtle.getItemCount() > 0 then 
            turtle.placeDown()
        else
            index = find_item('minecraft:sand')
            if index == nil then
                refill_sand()
                index find_item('minecraft:sand')
            end
            turtle.select(index)
        end
        has_block, data = turtle.inspectDown()
    end
    
end

function refill_sand()
    local saved_coords = deepcopy(COORDINATES)
    go_directly_to(COORDINATES.X, SAND_CHEST.Y+1, COORDINATES.Z)
    go_directly_to(SAND_CHEST.X, SAND_CHEST.Y+1, SAND_CHEST.Z)
    local empties = {}
    for i=1,16 do
        turtle.select(i)
        local details = turtle.getItemDetail()
        if details == nil or (details.name == 'minecraft:sand') then
            local wanted_amount = turtle.getItemSpace()
            local result = turtle.suckDown(wanted_amount)
            if result == false then
                error('Could not refill sand in slot ' .. i)
            end
        end
    end
    go_directly_to(saved_coords.X, saved_coords.Y, saved_coords.Z)
end

function refill_fuel()
    local saved_coords = deepcopy(COORDINATES)
    go_directly_to(COORDINATES.X, FUEL_CHEST.Y+1, COORDINATES.Z)
    go_directly_to(FUEL_CHEST.X, FUEL_CHEST.Y+1, FUEL_CHEST.Z)
    local empties = {}
    for i=1,16 do
        turtle.select(i)
        local details = turtle.getItemDetail()
        if details == nil or details.name == FUEL then
            local wanted_amount = turtle.getItemSpace()
            local result = turtle.suckDown(wanted_amount)
            if result == false then
                error('Could not refill fuel in slot ' .. i)
            end
        end
    end
    go_directly_to(saved_coords.X, saved_coords.Y, saved_coords.Z)
end

main()