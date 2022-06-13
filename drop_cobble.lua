local rt = require "retroturtle"

while true do
    local event = os.pullEvent("turtle_inventory")
    local junk = rt.find_junk()
    for k,v in pairs(junk) do
        turtle.select(v.index)
        turtle.drop()
    end
end