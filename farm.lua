require "retroturtle"

SEED = 'minecraft:wheat_seeds'
PLANT = 'minecraft:wheat'
GROWN_AGE = 7

function main()
    local length = tonumber(arg[1])
    local width = tonumber(arg[2])
    move_forward()
    for i=1,length do
        if i % 2 == 1 then
            turn_right()
        else
            turn_left()
        end
        for i=1,width do

        end
        if i < length then
            if i % 2 == 0 then
                turn_right()
            else
                turn_left()
            end
            move_forward()
        end 
    end
end

function dump_inv()

end

main()