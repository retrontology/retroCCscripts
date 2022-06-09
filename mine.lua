FUEL_INDEX = 1
TORCH_INDEX = 2

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
current_direction = DIRECTIONS.NORTH


function main()
    local length = tonumber(arg[1])
    mine_shaft(length)
end

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

function place_torch()
    torch_index = find_torch()
    if torch_index then
        turn_left()
        turn_left()
        turtle.select(torch_index)
        turtle.place()
        turn_left()
        turn_left()
    end
end

function vein_mine()

    local saved_direction = current_direction

    -- UP
    local has_block, data = turtle.inspectUp()
    if data.tags and data.tags['forge:ores'] then
        while has_block do
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
        while has_block do
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
        while has_block do
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
        while has_block do
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
        while has_block do
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
        while has_block do
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

function tunnel(segments, torch)
    local segment_count = 0
    while segment_count < segments do
        local count = 0
        while count < 8 do
            local has_block, data = turtle.inspect()
            while has_block do
                if has_block then
                    turtle.dig()
                end
                has_block, data = turtle.inspect()
            end
            move_forward()
            vein_mine()
            if torch and count == 4 then
                place_torch()
            end
            count = count + 1
        end
        segment_count = segment_count + 1
    end
    return true
end

function go_to_wall()
    while not turtle.detect() do
        move_forward()
    end
    return true
end

function turn_around()
    has_block, data = turtle.inspectUp()
    while turtle.detectUp() do
        turtle.digUp()
    end
    move_up()
    turn_left()
    turn_left()
end

function mine_shaft(length)
    tunnel(length, false)
    turn_around()
    tunnel(length, true)
    return true
end

main()