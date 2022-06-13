while true do
    local event = os.pullEvent("turtle_inventory")
    local junk = _G.find_junk()
    for k,v in pairs(junk) do
        turtle.select(v.index)
        turtle.drop()
    end
end