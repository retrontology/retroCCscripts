require "retroturtle"

BUCKET = 'minecraft:bucket'
WATER_BUCKET = 'minecraft:water_bucket'
DEFAULT_DELAY = 3
CUTOFF = 20

function main()
    local not_obs = 0
    while true do
        local has_block, data = turtle.inspectDown()
        if has_block then
            if data.name == 'minecraft:lava' then
                douse()
                has_block, data = turtle.inspectDown()
            end
            if data.name == 'minecraft:obsidian' then
                mine_down()
                not_obs = 0
                if inv_full() then
                    error_return('Inventory full!')
                end
            else
                not_obs = not_obs + 1
            end
            if not_obs > CUTOFF then
                error_return('Reached ' .. CUTOFF .. ' blocks in a row without finding obsidian...')
            end
        end
    end
end

function douse(delay)
    if delay == nil then
        delay = DEFAULT_DELAY
    end
    local bucket = find_item(WATER_BUCKET)
    if bucket == nil then
        error_return('Could not find water bucket!')
    end
    turtle.select(bucket)
    move_up()
    turtle.placeDown()
    sleep(delay)
    turtle.placeDown()
    move_down()
end

function error_return(err)
    go_directly_to(0, 0, 0)
    error(err)
end

main()