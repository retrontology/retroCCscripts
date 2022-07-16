require "retroturtle"

function main()
    local length = tonumber(arg[1])
    local width = tonumber(arg[2])
    break_floor(length, width)
end

function break_floor(length, width)
    for i=1,length do
        if i % 2 == 1 then
            turn_right()
        else
            turn_left()
        end
        for j=1,width-1 do
            mine_down()
            mine_forward()
            move_forward()
        end
        mine_down()
        if i < length then
            if i % 2 == 1 then
                turn_left()
            else
                turn_right()
            end
            mine_forward()
            move_forward()
        end
    end
end

main()