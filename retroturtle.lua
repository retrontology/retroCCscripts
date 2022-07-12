require "retrostd"

DEFAULT_GPS_TIMEOUT = 5

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

current_direction = DIRECTIONS.NORTH

ORIGIN = {
    X = COORDINATES.X,
    Y = COORDINATES.Y,
    Z = COORDINATES.Z,
    DIR = current_direction
}

PASSABLE = {
    'minecraft:water',
    'minecraft:bubble_column',
    'minecraft:lava',
    'pneumaticcraft:oil'
}

FUEL = {
    'minecraft:coal',
    'minecraft:charcoal'
}

mine_stack = {}

function sync_gps(timeout, set_origin)
    if timeout == nil then
        timeout = DEFAULT_GPS_TIMEOUT
    end
    COORDINATES.X, COORDINATES.Y, COORDINATES.Z = gps.locate(timeout)
    if set_origin == false then
        ORIGIN = {
            X = COORDINATES.X,
            Y = COORDINATES.Y,
            Z = COORDINATES.Z,
            DIR = current_direction
        }
    end
end

function sync_direction(timeout)
    sync_gps(timeout)
    saved_coords = deepcopy(COORDINATES)
    local result = false
    for i=1,4 do
        if move_forward() then
            result = true
            break
        else
            turn_left()
        end
    end
    if not result then
        error('Could not sync direction!!!')
    end
    sync_gps(timeout)
    local x_diff = COORDINATES.X - saved_coords.X
    local z_diff = COORDINATES.Z - saved_coords.Z
    if x_diff == 1 then
        current_direction = DIRECTIONS.EAST
    elseif x_diff == -1 then
        current_direction = DIRECTIONS.WEST
    elseif z_diff == 1 then
        current_direction = DIRECTIONS.SOUTH
    elseif z_diff == -1 then
        current_direction = DIRECTIONS.NORTH
    end
    move_backward()
end

function dump_inv()
    for i=1,16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item ~= nil then
            local result = turtle.drop()
            if result == false then
                error('Target inventory full!')
            end
        end
    end
end

function dump_inv_down()
    for i=1,16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item ~= nil then
            local result = turtle.dropDown()
            if result == false then
                error('Target inventory full!')
            end
        end
    end
end

function dump_inv_up()
    for i=1,16 do
        turtle.select(i)
        local item = turtle.getItemDetail()
        if item ~= nil then
            local result = turtle.dropUp()
            if result == false then
                error('Target inventory full!')
            end
        end
    end
end

function find_empty_slots()
    local saved_index = turtle.getSelectedSlot()
    local empties = {}
    for i=1,16 do
        turtle.select(i)
        if turtle.getItemDetail() == nil then
            empties[i] = true
        end
    end
    turtle.select(saved_index)
    return empties
end

function find_item(item)
    for i=1,16 do
        local details = turtle.getItemDetail(i)
        if details and details.name == item then
            return i
        end
    end
    return nil
end

function find_fuel()
    for i=1,16 do
        local details = turtle.getItemDetail(i)
        if details and contains(FUEL, details.name) then
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
    local result, err = turtle.forward()
    if result then 
        if current_direction == DIRECTIONS.NORTH then
            COORDINATES.Z = COORDINATES.Z - 1
        elseif current_direction == DIRECTIONS.EAST then
            COORDINATES.X = COORDINATES.X + 1
        elseif current_direction == DIRECTIONS.SOUTH then
            COORDINATES.Z = COORDINATES.Z + 1
        elseif current_direction == DIRECTIONS.WEST then
            COORDINATES.X = COORDINATES.X - 1
        end
    end
    return result, err
end

function move_backward()
    check_fuel()
    local result, err = turtle.back()
    if result then 
        if current_direction == DIRECTIONS.NORTH then
            COORDINATES.Z = COORDINATES.Z + 1
        elseif current_direction == DIRECTIONS.EAST then
            COORDINATES.X = COORDINATES.X - 1
        elseif current_direction == DIRECTIONS.SOUTH then
            COORDINATES.Z = COORDINATES.Z - 1
        elseif current_direction == DIRECTIONS.WEST then
            COORDINATES.X = COORDINATES.X + 1
        end
    end
    return result, err
end

function move_up()
    check_fuel()
    local result, err = turtle.up()
    if result then 
        COORDINATES.Y = COORDINATES.Y + 1
    end
    return result, err
end

function move_down()
    check_fuel()
    local result, err = turtle.down()
    if result then 
        COORDINATES.Y = COORDINATES.Y - 1
    end
    return result, err
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
    local result = false
    while has_block and not contains(PASSABLE, data.name) do
        result, err = turtle.dig()
        has_block, data = turtle.inspect()
    end
    return result, err
end

function mine_up()
    local has_block, data = turtle.inspectUp()
    local result = false
    while has_block and not contains(PASSABLE, data.name) do
        result, err = turtle.digUp()
        has_block, data = turtle.inspectUp()
    end
    return result, err
end

function mine_down()
    local has_block, data = turtle.inspectDown()
    local result = false
    while has_block and not contains(PASSABLE, data.name) do
        result, err = turtle.digDown()
        has_block, data = turtle.inspectDown()
    end
    return result, err
end

function place_item(item)
    local item = find_item(item)
    if item == nil then
        print('Could not find item: ' .. item .. '!!!')
        return false
    else
        turtle.select(item)
        return turtle.place()
    end
end

function place_item_down(item)
    local item = find_item(item)
    if item == nil then
        print('Could not find item: ' .. item .. '!!!')
        return false
    else
        turtle.select(item)
        return turtle.placeDown()
    end
end

function place_item_up(item)
    local item = find_item(item)
    if item == nil then
        print('Could not find item: ' .. item .. '!!!')
        return false
    else
        turtle.select(item)
        return turtle.placeUp()
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

function vein_mine(filter)

    local saved_direction = current_direction

    -- UP
    local has_block, data = turtle.inspectUp()
    if filter(data) then
        mine_up()
        local success, err = move_up()
        if success then
            table.insert(mine_stack, DIRECTIONS.UP)
            vein_mine(filter)
        else
            error(err .. " up")
        end
    end

    -- Forward
    local has_block, data = turtle.inspect()
    if filter(data) then
        mine_forward()
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine(filter)
        else
            error(err .. " forward")
        end
    end

    -- Left
    turn_left()
    local has_block, data = turtle.inspect()
    if filter(data) then
        mine_forward()
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine(filter)
        else
            error(err .. " forward")
        end
    end

    -- Behind
    turn_left()
    local has_block, data = turtle.inspect()
    if filter(data) then
        mine_forward()
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine(filter)
        else
            error(err .. " forward")
        end
    end

    -- Right
    turn_left()
    local has_block, data = turtle.inspect()
    if filter(data) then
        mine_forward()
        local success, err = move_forward()
        if success then
            table.insert(mine_stack, current_direction)
            vein_mine(filter)
        else
            error(err .. " up")
        end
    end

    -- Below
    local has_block, data = turtle.inspectDown()
    if filter(data) then
        mine_down()
        local success, err = move_down()
        if success then
            table.insert(mine_stack, DIRECTIONS.DOWN)
            vein_mine(filter)
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
    while not has_block and not contains(PASSABLE, data.name) do
        move_forward()
        has_block, data = turtle.inspect()
    end
    return true
end