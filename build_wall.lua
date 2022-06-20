require "retroturtle"

function main()
    local length = arg[1]
    local height = arg[2]
    build_wall(length, height)
end

function build_wall(length, height)

    for i=1,height do
        mine_up()
        move_up()
        if i % 2 == 1 then
            face_direction(DIRECTIONS.NORTH)
        else
            face_direction(DIRECTIONS.SOUTH)
        end
        for j=1,length-1 do
            
        end
    end
end

main()