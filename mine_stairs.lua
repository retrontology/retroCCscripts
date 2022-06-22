require "retroturtle"

STAIR_HEIGHT = 6

function main()
    local length = tonumber(arg[1])
end

function mine_stairs(length)
    local start_coords = COORDINATES
    for i=1,length do
        mine_forward()
        move_forward()
        start_coords = COORDINATES
        for i=1,STAIR_HEIGHT do
            turn_right()
        end
    end
main()