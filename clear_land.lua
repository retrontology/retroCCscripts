require "retroturtle"

SUBROUTINES = {
    drop_cobble = {}
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
        max_x = width-1,
        min_z = 1-length,
        max_z = 0
    }

    local edges_next = {
        min_x = width-1,
        max_x = 0,
        min_z = 0,
        max_z = 1-length
    }

    while true do 
        edges_next = {
            min_x = width-1,
            max_x = 0,
            min_z = 0,
            max_z = 1-length
        }
        face_direction(DIRECTIONS.EAST)
        for j=edges.min_z,edges.max_z do
            for k=edges.min_x,edges.max_x do

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
                        if z_bigger then
                            edges_next.max_z = COORDINATES.Z
                        end
                        if z_smaller then
                            edges_next.min_z = COORDINATES.Z
                        end
                    end
                end
                
                -- actual clearing
                if k < edges.max_x then
                    mine_forward()
                    move_forward()
                end
            end
            if j < edges.max_z then
                face_direction(DIRECTIONS.NORTH)
                mine_forward()
                move_forward()
                if (j - edges.min_z) % 2 == 1 then
                    face_direction(DIRECTIONS.EAST)
                else
                    face_direction(DIRECTIONS.WEST)
                end
            end
        end
        if edges_next.min_x == width-1 or edges_next.max_x == 0 or edges_next.min_z == 0 or edges_next.max_z == 1-length then
            go_directly_to(0, 0, 0)
            break
        else
            edges = edges_next
            go_directly_to(edges.min_x, COORDINATES.Y+1, edges.max_z)
        end
    end
end

main()