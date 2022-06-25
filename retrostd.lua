function contains(table, value)
    for k,v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
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