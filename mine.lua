require "retroturtle"

SUBROUTINES = {
    'drop_cobble'
}

function main()
    run_subroutines(SUBROUTINES)
    local length = tonumber(arg[1])
    mine_shaft(length)
end

function tunnel(segments, torch)
    local segment_count = 0
    while segment_count < segments do
        local count = 0
        while count < 8 do
            local has_block, data = turtle.inspect()
            while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
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
    while has_block and data.name ~= 'minecraft:water' and data.name ~= 'minecraft:bubble_column' do
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

function place_torch()
    local select = turtle.getSelectedSlot()
    torch_index = find_item('minecraft:torch')
    if torch_index then
        turn_left()
        turn_left()
        turtle.select(torch_index)
        turtle.place()
        turn_left()
        turn_left()
        turtle.select(select)
    end
end

main()