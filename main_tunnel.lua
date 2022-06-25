require "retroturtle"

SUBROUTINES = {
    drop_cobble = {}
}

DEFAULT_WIDTH = 4
DEFAULT_HEIGHT = 4

function main()
    run_subroutines(SUBROUTINES)
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
    local z_dir = true

    for i=1,length do
        mine_forward()
        move_forward()
        if odd and i % 2 == 0 then
            turn_left()
        else
            turn_right()
        end
        for j=1,height do
            for k=1,width-1 do
                mine_forward()
                move_forward()
            end
            if j ~= height then
                if z_dir then
                    mine_up()
                    move_up()
                else
                    mine_down()
                    move_down()
                end
                turn_left()
                turn_left()
            end
        end
        z_dir = not z_dir
        if odd and i % 2 == 0 then
            turn_left()
        else
            turn_right()
        end
    end
end

main()