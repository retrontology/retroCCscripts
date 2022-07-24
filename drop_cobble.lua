JUNK = {
    'minecraft:cobblestone',
    'minecraft:cobbled_deepslate',
    'minecraft:dirt',
    'minecraft:gravel',
    'minecraft:netherrack',
    'minecraft:soul_sand',
    'minecraft:mossy_cobblestone',
    'minecraft:tuff',
    'minecraft:calcite',
    'minecraft:basalt',
    'minecraft:polished_basalt',
    'minecraft:smooth_basalt',
    'minecraft:granite',
    'minecraft:diorite',
    'minecraft:andesite',
    'minecraft:blackstone',
    'minecraft:calcite',
    'create:limestone',
    'minecraft:flint'
}

function main()
    local filter = JUNK
    while true do
        local event = os.pullEvent("turtle_inventory")
        local index = turtle.getSelectedSlot()
        local junk = find_junk(filter)
        for k,v in pairs(junk) do
            turtle.select(v.index)
            turtle.drop()
        end
        turtle.select(index)
    end
end

function contains(table, value)
    for k,v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end

function find_junk(filter)
    local results = {}
    for i=1,16 do
        local details = turtle.getItemDetail(i)
        if details and contains(JUNK, details.name) then
            table.insert(results, {index=i, details=details})
        end
    end
    return results
end

main()