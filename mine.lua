FUEL_INDEX = 1
TORCH_INDEX = 2

DIRECTIONS = {
    NORTH = 0,
    EAST = 1,
    SOUTH = 2,
    WEST = 3
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
        details = turtle.getItemDetail(i)
        if details.name == 'minecraft:coal' or details.name == 'minecraft:charcoal' then
            return i
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
    turtle.forward()
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
    turtle.back()
end

function move_up()
    check_fuel()
    COORDINATES.Y = COORDINATES.Y + 1
    turtle.up()
end

function move_down()
    check_fuel()
    COORDINATES.Y = COORDINATES.Y - 1
    turtle.down()
end

function place_torch()
    turn_left()
    turn_left()
    turtle.select(2)
    turtle.place()
    turn_left()
    turn_left()
end

function vein_mine()
    local has_block, data = turtle.inspectUp()
    if has_block then

        vein_mine()
    end
    local has_block, data = turtle.inspectDown()
    if turtle.inspectDown() then
        
        vein_mine()
    end
    turn_left()
    local has_block, data = turtle.inspect()
    if has_block then

        vein_mine()
    end
    turn_left()
    local has_block, data = turtle.inspect()
    if has_block then

        vein_mine()
    end
    turn_left()
    local has_block, data = turtle.inspect()
    if has_block then

        vein_mine()
    end
    if #mine_stack > 0 then
        direction = table.remove(mine_stack)
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
    local has_block, data = turtle.inspect()
    while not has_block do
        move_forward()
        has_block, data = turtle.inspect()
    end
    return true
end

function turn_around()
    has_block, data = turtle.inspectUp()
    if has_block then
        turtle.digUp()
    end
    move_up()
    turn_left()
    turn_left()
end

function mine_shaft(length)
    go_to_wall()
    tunnel(length, false)
    turn_around()
    tunnel(length, true)
    return true
end

main()