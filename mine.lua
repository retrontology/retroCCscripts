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
    Y = 0
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
        if details.name == 'minecraft:coal'
        break
    end
end

function check_fuel(index)
    local fuel = turtle.getFuelLevel()
    if fuel == 0 then
        if index == nil then
            
        end
        turtle.select(1)
        if not turtle.refuel() then
            error('RAN OUT OF FUEL!!!')
        end
    end
end

function turn_left()
    turtle.turnLeft()
    direction = (direction - 1) % #DIRECTIONS
end

function turn_right()
    turtle.turnRight()
    direction = (direction + 1) % #DIRECTIONS
end

function move()
    check_fuel()
    turtle.forward()
end

function move_up()

end

function move_down()

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
            if has_block then
                turtle.dig()
            end
            move()
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
        move()
        has_block, data = turtle.inspect()
    end
    return true
end

function turn_around()
    has_block, data = turtle.inspectUp()
    if has_block then
        turtle.digUp()
    end
    turtle.up()
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