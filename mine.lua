function tunnel(length)
    local count = 0
    while count < length do
        local has_block, data = turtle.inspect()
        if has_block then
            turtle.dig()
        end
        count = count + 1
    end
end

function go_to_wall()
    local has_block, data = turtle.inspect()
    while not has_block do
        turtle.forward()
        has_block, data = turtle.inspect()
    end
end

function mine_shaft(length)
    go_to_wall()
    tunnel(length)
end