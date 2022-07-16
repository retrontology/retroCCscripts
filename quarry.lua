require "break_floor"

function main()
    local length = tonumber(arg[1])
    local width = tonumber(arg[2])
    local height = tonumber(arg[3])
    quarry(length, width, height)
end

function quarry(length, width, height)
    for i=1,height do
        break_floor(length, width)
        mine_down()
        move_down()
        turn_right()
        if length % 2 == 0 then
            turn_right()
        end
    end
end

main()