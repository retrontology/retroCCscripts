function move()
    local fuel = turtle.getFuelLevel()
    if fuel == 0 then
        if not turtle.refuel() then
            error('RAN OUT OF FUEL!!!')
        end
    end
    turtle.forward()
end

function tunnel(length)
    local count = 0
    while count < length do
        local has_block, data = turtle.inspect()
        if has_block then
            turtle.dig()
        end
        move()
        count = count + 1
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

function turn_around

end

function turn_around()

function mine_shaft(length)
    go_to_wall()
    tunnel(length)
    turn_around()
    tunnel(length)
    return true
end

mine_shaft(20)