require "retroturtle"

function main()
    local item = arg[1]
    local length = tonumber(arg[2])
    local width = tonumber(arg[3])
    build_floor(item, length, width)
end

function build_floor(item, length, width)
    for i=1,length-1 do
        if i % 2 == 1 then
            turn_right()
        else
            turn_left()
        end
        for j=1,width-1 do
            mine_down()
            local result = place_item_down(item)
            if not result then
                error('Could not place item')
            end
            mine_forward()
            move_forward()
        end
        mine_down()
        local result = place_item_down(item)
        if not result then
            error('Could not place item')
        end
        if i % 2 == 1 then
            turn_left()
        else
            turn_right()
        end
        mine_forward()
        move_forward()
    end
    go_directly_to(0, 0, 0)
end

main()