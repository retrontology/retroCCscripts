require "retroturtle"

SUBROUTINES = {
    'drop_cobble'
}

function main()
    run_subroutines(SUBROUTINES)
    local length = tonumber(arg[1])
    local width = tonumber(arg[2])
    local height = tonumber(arg[3])
    clear_land(length, width)
end

function clear_land(length, width)
    local edges = {
        min_x = 0,
        max_x = length-1,
        min_z = 0,
        max_z = width-1
    }

    local edges_next = {
        min_x = length,
        max_x = 0,
        min_z = width,
        max_z = 0
    }

    while true do 
        edges_next = {
            min_x = length,
            max_x = 0,
            min_z = width,
            max_z = 0
        }
        face_direction(DIRECTIONS.WEST)
        for j=edges.min_x,edges.max_x do
            for k=edges.min_z,edges.max_z do

                -- store comparisons in memory
                local x_bigger = COORDINATES.X > edges_next.max_x
                local x_smaller = COORDINATES.X < edges_next.min_x
                local z_bigger = COORDINATES.Z > edges_next.max_z
                local z_smaller = COORDINATES.Z < edges_next.min_z

                -- measure next layer edges
                if x_bigger or x_smaller or z_bigger or z_smaller then
                    local has_block = turtle.detectUp()
                    if has_block then
                        if x_bigger then
                            edges_next.max_x = COORDINATES.X
                        end
                        if x_smaller then
                            edges_next.min_x = COORDINATES.X
                        end
                        if y_bigger then
                            edges_next.max_z = COORDINATES.Z
                        end
                        if y_smaller then
                            edges_next.min_z = COORDINATES.Z
                        end
                    end
                end
                
                -- actual clearing
                if k < edges.max_z then
                    mine_forward()
                    move_forward()
                end
            end
            if j < edges.max_x then
                print(current_direction)
                face_direction(DIRECTIONS.SOUTH)
                print(current_direction)
                io.input()
                mine_forward()
                move_forward()
                if (j - edges.min_x) % 2 == 1 then
                    face_direction(DIRECTIONS.WEST)
                else
                    face_direction(DIRECTIONS.EAST)
                end
            end
        end
        if edges_next.min_x == length or edges_next.max_x == 0 or edges_next.min_z == width or edges_next.max_z == 0 then
            go_directly_to(0, 0, 0)
            break
        else
            go_directly_to(edges.min_x, edges.min_z, COORDINATES.Y+1)
            edges = edges_next
        end
    end
end

main()