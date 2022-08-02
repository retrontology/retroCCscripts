require "retroturtle"

BUCKET = 'minecraft:bucket'
WATER_BUCKET = 'minecraft:water_bucket'
DEFAULT_DELAY = 3
CUTOFF = 2

SUBROUTINES = {
    drop_cobble = {}
}

function main()
    run_subroutines(SUBROUTINES)
    local row_count = 0
    local non_valid = 0
    mine_forward()
    move_forward()
    local has_block, data = turtle.inspectDown()
    while true do
        if row_count % 2 == 0 then
            face_direction(DIRECTIONS.EAST)
        else
            face_direction(DIRECTIONS.WEST)
        end
        has_block, data = turtle.inspectDown()
        if has_block then
            if data.name == 'minecraft:lava' then
                douse()
                has_block, data = turtle.inspectDown()
            end
            if data.name == 'minecraft:obsidian' or data.name == 'minecraft:cobblestone' then
                mine_down()
                if inv_full() then
                    error_return('Inventory full!')
                end
                mine_forward()
                move_forward()
                non_valid = 0
            else
                non_valid = non_valid + 1
                if non_valid >= CUTOFF then
                    error_return('Cutoff exceeded!')
                end
                move_backward()
                face_direction(DIRECTIONS.NORTH)
                mine_forward()
                move_forward()
                row_count = row_count + 1
                if row_count % 2 == 1 then
                    face_direction(DIRECTIONS.EAST)
                else
                    face_direction(DIRECTIONS.WEST)
                end
                has_block, data = turtle.inspectDown()
                while has_block and (data.name == 'minecraft:lava' or data.name == 'minecraft:obsidian' or data.name == 'minecraft:cobblestone') do
                    mine_forward()
                    move_forward()
                    has_block, data = turtle.inspectDown()
                end
                turn_left()
                turn_left()
                move_forward()
                print('Starting row ' .. row_count)
            end
        end
    end
end

function douse(delay)
    if delay == nil then
        delay = DEFAULT_DELAY
    end
    local bucket = find_item(WATER_BUCKET)
    if bucket == nil then
        error_return('Could not find water bucket!')
    end
    turtle.select(bucket)
    move_up()
    turtle.placeDown()
    sleep(delay)
    turtle.placeDown()
    move_down()
end

function error_return(err)
    go_directly_to(0, 0, 0)
    error(err)
end

function inv_full()
    return false
end

main()