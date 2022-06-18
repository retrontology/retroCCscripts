function contains(table, value)
    for k,v in ipairs(table) do
        if v == value then
            return true
        end
    end
    return false
end