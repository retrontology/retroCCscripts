function contains(table, value)
    for k,v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function run_subroutines(subroutines)
    for k,v in pairs(subroutines) do
        local count = multishell.getCount()
        local running = false
        for i=1,count do
            local title = multishell.getTitle(i)
            if title == k then
                running = true
                break
            end
        end
        if not running then
            local temp = multishell.launch(_G, k .. '.lua', v)
            multishell.setTitle(temp, k)
        end
    end
end