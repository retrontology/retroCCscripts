require "retroturtle"

function main()
    local item = arg[1]
    local length = tonumber(arg[2])
    local width = tonumber(arg[3])
    local height = tonumber(arg[4])
    build_walls(item, length, width, height)
end

function build_walls(item, length, width, height)
    for i=1,height-1 do
        move_up()
        for j=1,2 do
            for k=1,length-1 do
                local result = place_item_down(item)
                if not result then
                    error('Could not place item')
                else
                    move_forward()
                end
            end
            turn_right()
            for k=1,width do
                local result = place_item_down(item)
                if not result then
                    error('Could not place item')
                else
                    move_forward()
                end
            end
            turn_right()
        end
    end
end

main()