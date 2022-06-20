require "retroturtle"

function main()
    local item = arg[1]
    local length = tonumber(arg[2])
    local width = tonumber(arg[3])
    build_floor(item, length, width)
end

function build_floor(item, length, width)
    for i=1,length do
        if i % 2 == 1 then
            turn_right()
        else
            turn_left()
        end
        for j=1,width do
            local result = place_item_down(item)
            if result then
                move_forward()
            else
                error('Could not place item')
            end
        end
    end
end

main()