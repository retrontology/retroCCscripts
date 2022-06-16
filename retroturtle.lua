DIRECTIONS = {
    NORTH = 0,
    EAST = 1,
    SOUTH = 2,
    WEST = 3,
    UP = 4,
    DOWN = 5
}

COORDINATES = {
    X = 0,
    Y = 0,
    Z = 0
}

mine_stack = {}
current_direction = DIRECTIONS.SOUTH

function find_fuel()
    for i=1,16 do
        local details = turtle.getItemDetail(i)
        if details and (details.name == 'minecraft:coal' or details.name == 'minecraft:charcoal') then
            return i
        end
    end
    return nil
end

function find_torch()
    for i=1,16 do
        local details = turtle.getItemDetail(i)
        if details and details.name == 'minecraft:torch' then
            return i
        end
    end
    return nil
end

function check_fuel(index)
    local fuel = turtle.getFuelLevel()
    if fuel == 0 then
        local select = turtle.getSelectedSlot()
        if index == nil then
            index = find_fuel()
            if index == nil then
                error('RAN OUT OF FUEL!!!')
            end
        end
        turtle.select(index)
        if not turtle.refuel() then
            error('COULD NOT REFUEL!!!')
        end
        turtle.select(select)
    end
end

function turn_left()
    turtle.turnLeft()
    current_direction = (current_direction - 1) % 4
end

function turn_right()
    turtle.turnRight()
    current_direction = (current_direction + 1) % 4
end

function move_forward()
    check_fuel()
    if current_direction == DIRECTIONS.NORTH then
        COORDINATES.Z = COORDINATES.Z - 1
    elseif current_direction == DIRECTIONS.EAST then
        COORDINATES.X = COORDINATES.X + 1
    elseif current_direction == DIRECTIONS.SOUTH then
        COORDINATES.Z = COORDINATES.Z + 1
    elseif current_direction == DIRECTIONS.WEST then
        COORDINATES.X = COORDINATES.X - 1
    end
    return turtle.forward()
end

function move_backward()
    check_fuel()
    if current_direction == DIRECTIONS.NORTH then
        COORDINATES.Z = COORDINATES.Z + 1
    elseif current_direction == DIRECTIONS.EAST then
        COORDINATES.X = COORDINATES.X - 1
    elseif current_direction == DIRECTIONS.SOUTH then
        COORDINATES.Z = COORDINATES.Z - 1
    elseif current_direction == DIRECTIONS.WEST then
        COORDINATES.X = COORDINATES.X + 1
    end
    return turtle.back()
end

function move_up()
    check_fuel()
    COORDINATES.Y = COORDINATES.Y + 1
    return turtle.up()
end

function move_down()
    check_fuel()
    COORDINATES.Y = COORDINATES.Y - 1
    return turtle.down()
end

function face_direction(target_direction)
    while current_direction ~= target_direction do
        local left_score = ((target_direction - current_direction) + 4) % 4
        local right_score = ((current_direction - target_direction) + 4) % 4
        if right_score > left_score then
            turn_right()
        else
            turn_left()
        end
    end
end

function mine_forward()
    local has_block, data = turtle.inspect()
    while has_block do
        turtle.dig()
        has_block, data = turtle.inspect()
    end
end

function mine_up()
    local has_block, data = turtle.inspectUp()
    while has_block do
        turtle.digUp()
        has_block, data = turtle.inspectUp()
    end
end

function mine_down()
    local has_block, data = turtle.inspectDown()
    while has_block do
        turtle.digDown()
        has_block, data = turtle.inspectDown()
    end
end

function go_directly_to(x, y, z)
    while COORDINATES.X ~= x do
        if COORDINATES.X < x then
            face_direction(DIRECTIONS.EAST)
            mine_forward()
            move_forward()
        elseif COORDINATES.X > x then
            face_direction(DIRECTIONS.WEST)
            mine_forward()
            move_forward()
        end
    end
    while COORDINATES.Z ~= z do
        if COORDINATES.Z < z then
            face_direction(DIRECTIONS.SOUTH)
            mine_forward()
            move_forward()
        elseif COORDINATES.Z > z then
            face_direction(DIRECTIONS.NORTH)
            mine_forward()
            move_forward()
        end
    end
    while COORDINATES.Y ~= y do
        if COORDINATES.Y < y then
            mine_up()
            move_up()
        elseif COORDINATES.Y > y then
            mine_down()
            move_down()
        end
    end

end

function vein_mine()

    local saved_direction = current_direction

    -- UP
    local has_block, data = turtle.inspectUp()
    if data.tags and data.tags['forge:ores'] then
        while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
            turtle.digUp()
            has_block, data = turtle.inspectUp()
        end
        local success, err = move_up()
        if success then
            table.insert(mine_stack, DIRECTIONS.UP)
            vein_mine()
        else
            error(err .. " up")
        end
    end

    -- Forward
    local has_block, data = turtle.inspect()
    if data.tags and data.tags['forge:ores'] then
        while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
            turtle.dig()
            has_block, data = turtle.inspect()
        end
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine()
        else
            error(err .. " forward")
        end
    end

    -- Left
    turn_left()
    local has_block, data = turtle.inspect()
    if data.tags and data.tags['forge:ores'] then
        while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
            turtle.dig()
            has_block, data = turtle.inspect()
        end
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine()
        else
            error(err .. " forward")
        end
    end

    -- Behind
    turn_left()
    local has_block, data = turtle.inspect()
    if data.tags and data.tags['forge:ores'] then
        while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
            turtle.dig()
            has_block, data = turtle.inspect()
        end
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine()
        else
            error(err .. " forward")
        end
    end

    -- Right
    turn_left()
    local has_block, data = turtle.inspect()
    if data.tags and data.tags['forge:ores'] then
        while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
            turtle.dig()
            has_block, data = turtle.inspect()
        end
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine()
        else
            error(err .. " up")
        end
    end

    -- Below
    local has_block, data = turtle.inspectDown()
    if data.tags and data.tags['forge:ores'] then
        while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
            turtle.digDown()
            has_block, data = turtle.inspectDown()
        end
        local success, err = move_down()
        if success then
            table.insert(mine_stack, DIRECTIONS.DOWN)
            vein_mine()
        else
            error(err .. " down")
        end
    end

    -- Return
    if #mine_stack > 0 then
        local direction = table.remove(mine_stack)
        if direction == DIRECTIONS.UP then
            local success, err = move_down()
            if not success then
                error(err .. " down")
            end
        elseif direction == DIRECTIONS.DOWN then
            local success, err = move_up()
            if not success then
                error(err .. " up")
            end
        else
            face_direction(direction)
            local success, err = move_backward()
            if not success then
                error(err .. " backward")
            end
        end
    else
        face_direction(saved_direction)
    end
end

function go_to_wall()
    local has_block, data = turtle.inspect()
    while not has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
        move_forward()
        has_block, data = turtle.inspect()
    end
    return true
end

function run_subroutines(subroutines)
    for k,v in pairs(subroutines) do
        local count = multishell.getCount()
        local running = false
        for i=1,count do
            local title = multishell.getTitle(i)
            if title == v then
                running = true
                break
            end
        end
        if not running then
            local temp = multishell.launch(_G, v .. '.lua')
            multishell.setTitle(temp, v)
        end
    end
end