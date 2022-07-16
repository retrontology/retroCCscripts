require "retroturtle"

SEA_LEVEL = 38

SAND_CHEST = {
    X=320,
    Y=63,
    Z=-205
}

GLASS_CHEST = {
    X=320,
    Y=63,
    Z=-203
}

MONUMENT_NW_CORNER = {
    X=323,
    Z=-205
}

MONUMENT_BASE_Y = 39

function main()
    local command = arg[1]
    if command == 'fill' then
        local offset = 0
        if arg[2] ~= nil then
            offset = tonumber(arg[2])
        end
        fill_monument(MONUMENT_NW_CORNER.X, MONUMENT_NW_CORNER.Z, offset)
    elseif command == 'clear' then
        local offset = 0
        if arg[2] ~= nil then
            offset = tonumber(arg[2])
        end
        clear_monument(MONUMENT_NW_CORNER.X, MONUMENT_BASE_Y, MONUMENT_NW_CORNER.Z, offset)
    elseif command == 'shell' then
        build_shell(MONUMENT_NW_CORNER.X, MONUMENT_BASE_Y, MONUMENT_NW_CORNER.Z)
    else
        error('You must specify either fill, clear, or shell')
    end
end

function build_shell(x, base_y, z)
    sync_direction()
    x = x - 1
    z = z - 1
    for i=0,58 do
        go_directly_to(x+i, SEA_LEVEL+1, z)
        build_column('minecraft:glass', GLASS_CHEST)
    end
    for i=0,58 do
        go_directly_to(x+59, SEA_LEVEL+1, z+i)
        build_column('minecraft:glass', GLASS_CHEST)
    end
    for i=0,58 do
        go_directly_to(x+59-i, SEA_LEVEL+1, z+59)
        build_column('minecraft:glass', GLASS_CHEST)
    end
    for i=0,58 do
        go_directly_to(x, SEA_LEVEL+1, z+59-i)
        build_column('minecraft:glass', GLASS_CHEST)
    end
end

function build_column(material, refill_chest)
    local has_block, data = turtle.inspectDown()
    if has_block and data.name == material then
        return
    end
    go_directly_to(COORDINATES.X, 0, COORDINATES.Z)
    while COORDINATES.Y < SEA_LEVEL + 1 do
        move_up()
        local index = find_item(material)
        if index == nil then
            refill_material(material, refill_chest)
            index = find_item(material)
        end
        turtle.select(index)
        turtle.placeDown()
    end
end

function clear_monument(x, base_y, z, offset)
    sync_direction()
    local start_y = SEA_LEVEL + 1 - offset
    go_directly_to(x, start_y, z)
    face_direction(DIRECTIONS.EAST)
    quarry(58, 58, start_y - base_y + 1)
end

function clear_monument_old(x, base_y, z, offset)
    if offset == nil then
        offset = 0
    end
    sync_direction()
    local height = SEA_LEVEL - base_y - offset
    local y = SEA_LEVEL + 1 - offset
    for i=1,height do
        for j=0,57 do
            for k=0,57 do
                go_directly_to(x+j, y, z+k)
                if not mine_down() then
                    fill_sand()
                    mine_down()
                end
            end
        end
        y = y - 1
    end
    dump_inv()
end

function fill_monument(x, z, offset)
    sync_direction()
    go_directly_to(x+offset, SEA_LEVEL + 1, z)
    face_direction(DIRECTIONS.EAST)
    for i=1+offset,58 do
        if i-offset % 2 == 1 then
            turn_right()
        else
            turn_left()
        end
        for j=1,58-1 do
            fill_sand()
            mine_forward()
            move_forward()
        end
        fill_sand()
        if i < 58 then
            if i-offset % 2 == 1 then
                turn_left()
            else
                turn_right()
            end
            mine_forward()
            move_forward()
        end
    end
end

function fill_monument_old(x, z, offset)
    sync_direction()
    if offset == nil then
        offset = 0
    end
    --x = x - 1
    --z = z - 1
    --for i=0,59 do
    for i=offset,57 do
        --for j=0,59 do
        for j=0,57 do
            go_directly_to(x+i, SEA_LEVEL + 1, z+j)
            fill_sand()
        end
    end
end

function fill_sand()
    local index = find_item('minecraft:sand')
    if index == nil then
        refill_material('minecraft:sand', SAND_CHEST)
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
                refill_material('minecraft:sand', SAND_CHEST)
                index = find_item('minecraft:sand')
            end
            turtle.select(index)
        end
        has_block, data = turtle.inspectDown()
    end

end

function refill_material(material, chest_location)
    local saved_coords = deepcopy(COORDINATES)
    go_directly_to(COORDINATES.X, chest_location.Y+1, COORDINATES.Z)
    go_directly_to(chest_location.X, chest_location.Y+1, chest_location.Z)
    for i=1,16 do
        turtle.select(i)
        local details = turtle.getItemDetail()
        if details ~= nil and (details.name ~= material) then
            turtle.drop()
        end
        local wanted_amount = turtle.getItemSpace()
        local result = turtle.suckDown(wanted_amount)
        if result == false then
            error('Could not refill ' .. material .. ' in slot ' .. i)
        end
    end
    go_directly_to(saved_coords.X, saved_coords.Y, saved_coords.Z)
end

main()