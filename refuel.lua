function main()
    refills = tonumber(arg[1])
    for i=1,refills do
        turtle.place()
        turtle.refuel()
    end
end

main()