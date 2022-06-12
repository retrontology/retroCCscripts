require "retroturtle"

DEFAULT_WIDTH = 4
DEFAULT_HEIGHT = 4

function main()
    local length = tonumber(arg[1])
    local width = tonumber(arg[2])
    local height = tonumber(arg[3])
    main_tunnel(length, width, height)
end

function main_tunnel(length, width, height)

    if length == nil then
        error('The length parameter is required!')
    end
    if width == nil then
        width = DEFAULT_WIDTH
    end
    if height == nil then
        height = DEFAULT_HEIGHT
    end

    local odd = (height % 2) == 1

    for i=1,length do
        mine_forward()
        move_forward()
        if odd then
            if i % 2 == 1 then
                turn_right()
            else
                turn_left()
            end
        end
        for j=1,height do
            for k=1,width-1 do
                mine_forward()
                move_forward()
            end
            if j ~= height then
                mine_up()
                move_up()
                turn_left()
                turn_left()
            end
        end
        if odd then
            if i % 2 == 1 then
                turn_right()
            else
                turn_left()
            end
        end
    end
end

main()