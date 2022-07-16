require "retroturtle"

function main()
    local length = tonumber(arg[1])
    local width = tonumber(arg[2])
    break_floor(length, width)
end

function break_floor(length, width, height)
    for i=1,height do
        for j=1,length do
            if j % 2 == 1 then
                turn_right()
            else
                turn_left()
            end
            for k=1,width-1 do
                mine_down()
                mine_forward()
                move_forward()
            end
            mine_down()
            if j < length then
                if j % 2 == 1 then
                    turn_left()
                else
                    turn_right()
                end
                mine_forward()
                move_forward()
            end
        end
    end
    go_directly_to(0, 0, 0)
end

main()