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

function calculate_distance(x1, y1, z1, x2, y2, z2)
    return math.abs(x2-x1) + math.abs(y2-y1) + math.abs(z2-z1)
end

function calculate_direct_distance(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

function download(url, path)
    local result = http.get(full_url)
    if path == nil then 
        path = basename(full_url)
    end
    if not result then
        error('Could not download ' .. full_url)
    else
        local outfile = fs.open(path)
        outfile.write(result.readAll())
        outfile.close()
    end
    result.close()
end

function dirname(path)
    return string.match(fullpath, ".*/")
end

function basename(path)
    return string.match(fullpath, ".*/(.*)")
end