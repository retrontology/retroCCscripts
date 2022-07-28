require "retroturtle"

BUCKET = 'minecraft:bucket'
WATER_BUCKET = 'minecraft:water_bucket'
DEFAULT_DELAY = 3

SUBROUTINES = {
    drop_cobble = {}
}

function main()
    run_subroutines(SUBROUTINES)
    while true do
        if row_count % 2 == 0 then
            face_direction(DIRECTIONS.EAST)
        else
            face_direction(DIRECTIONS.WEST)
        end
        local has_block, data = turtle.inspectDown()
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
            else
                move_backward()
                face_direction(DIRECTIONS.NORTH)
                move_forward()
                row_count += 1


                
                if row_count % 2 == 0 then
                    face_direction(DIRECTIONS.EAST)
                else
                    face_direction(DIRECTIONS.WEST)
                end
                has_block, data = turtle.inspectDown()
                
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