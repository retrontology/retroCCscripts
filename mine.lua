function move()
    local fuel = turtle.getFuelLevel()
    if fuel == 0 then
        turtle.select(1)
        if not turtle.refuel() then
            error('RAN OUT OF FUEL!!!')
        end
    end
    turtle.forward()
end

function place_torch()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.select(2)
    turtle.place()
    turtle.turnLeft()
    turtle.turnLeft()
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
            if torch and count == 5 then
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
    turtle.turnLeft()
    turtle.turnLeft()
end

function mine_shaft(length)
    go_to_wall()
    tunnel(length)
    turn_around()
    tunnel(length)
    return true
end

mine_shaft(2)