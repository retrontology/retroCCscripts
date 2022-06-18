JUNK = {
    'minecraft:cobblestone',
    'minecraft:cobbled_deepslate',
    'minecraft:dirt',
    'minecraft:gravel'
}

function contains(table, value)
    for k,v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function find_junk()
    local results = {}
    for i=1,16 do
        local details = turtle.getItemDetail(i)
        if details and contains(JUNK, details.name) then
            table.insert(results, {index=i, details=details})
        end
    end
    return results
end

while true do
    local event = os.pullEvent("turtle_inventory")
    local select = turtle.getSelectedSlot()
    local junk = find_junk()
    for k,v in pairs(junk) do
        turtle.select(v.index)
        turtle.drop()
    end
    turtle.select(select)
end