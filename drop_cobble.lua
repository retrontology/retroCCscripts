function find_junk()
    local results = {}
    for i=1,16 do
        local details = turtle.getItemDetail(i)
        if details and (details.name == 'minecraft:cobblestone' or details.name == 'minecraft:cobbled_deepslate') then
            table.insert(results, {index=i, details=details})
        end
    end
    return results
end

while true do
    local event = os.pullEvent("turtle_inventory")
    local junk = find_junk()
    for k,v in pairs(junk) do
        turtle.select(v.index)
        turtle.drop()
    end
end