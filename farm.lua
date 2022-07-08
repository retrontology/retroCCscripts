require "retroturtle"

SEED = 'minecraft:wheat_seeds'
PLANT = 'minecraft:wheat'
GROWN_AGE = 7

function main()
    local length = tonumber(arg[1])
    local width = tonumber(arg[2])
    move_forward()
    for i=1,length do
        if i % 2 == 1 then
            turn_right()
        else
            turn_left()
        end
        for j=1,width do
            local has_block, data = turtle.inspectDown()
            if has_block and data.name == PLANT and data.stage.age == GROWN_AGE then
                turtle.digDown()
            end
            has_block, data = turtle.inspectDown()
            if not has_block then
                local index = find_item(SEED)
                if index == nil then
                    dump_harvest()
                    error('Ran out of seeds!')
                end
                turtle.select(index)
                turtle.placeDown()
            end
            if j < width then
                move_forward()
            end
        end
        if i < length then
            if i % 2 == 0 then
                turn_right()
            else
                turn_left()
            end
            move_forward()
        end 
    end
    dump_harvest()
end

function dump_harvest()
    go_directly_to(0,0,0)
    face_direction(DIRECTIONS.NORTH)
    dump_inv_down()
end

main()