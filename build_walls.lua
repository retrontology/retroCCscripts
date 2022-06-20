require "retroturtle"

function main()
    local item = arg[1]
    local length = tonumber(arg[2])
    local width = tonumber(arg[3])
    local height = tonumber(arg[4])
    build_walls(item, length, width, height)
end

function build_walls(item, length, width, height)
    move_up()
    for i=1,height do
        for j=1,2 do
            for k=1,length do
                local result = place_item_down(item)
                if not result then
                    error('Ran out of specified item')
                else
                    move_forward()
                end
            end
            turn_right()
            for k=1,width do
                local result = place_item_down(item)
                if not result then
                    error('Ran out of specified item')
                else
                    move_forward()
                end
            end
            turn_right()
        end
    end
end

main()