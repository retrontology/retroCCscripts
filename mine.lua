require "retroturtle"

function main()
    local length = tonumber(arg[1])
    mine_shaft(length)
end

function tunnel(segments, torch)
    local segment_count = 0
    while segment_count < segments do
        local count = 0
        while count < 8 do
            local has_block, data = turtle.inspect()
            while has_block and data.name ~= 'minecraft:water' do
                turtle.dig()
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

function turn_around()
    local has_block, data = turtle.inspectUp()
    while has_block and data.name ~= 'minecraft:water' do
        turtle.digUp()
        has_block, data = turtle.inspectUp()
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