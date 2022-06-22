require "retroturtle"

SUBROUTINES = {
    drop_cobble = {}
}

function filter_ore(data)
    return data.tags and data.tags['forge:ores']
end

function filter_debris(data)
    return data.tags and data.name == 'minecraft:ancient_debris'
end

function main()
    local mine_type = arg[1]
    local length = tonumber(arg[2])
    local filter = nil
    if mine_type == 'ore' then
        SUBROUTINES['drop_cobble'] = {}
        filter = filter_ore
    elseif mine_type == 'debris' then
        SUBROUTINES['drop_cobble'] = {'nether'}
        filter = filter_debris
    end
    run_subroutines(SUBROUTINES)
    mine_shaft(filter, length)
end

function tunnel(filter, segments, torch)
    local segment_count = 0
    while segment_count < segments do
        local count = 0
        while count < 8 do
            mine_forward()
            move_forward()
            vein_mine(filter)
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
    mine_up()
    move_up()
    turn_left()
    turn_left()
end

function mine_shaft(filter, length)
    tunnel(filter, length, false)
    turn_around()
    tunnel(filter, length, true)
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