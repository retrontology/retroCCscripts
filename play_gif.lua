os.loadAPI("GIF")

function main()
    file = arg[1]
    play(file)
end

function play(file)
    local gifs = fs.find("*.gif")  -- Note: fs.find() is case-sensitive, even if your file system isn't.

    mon.setTextScale(0.5)
    local x, y = mon.getSize()

    local image = GIF.loadGIF(file)
    mon.setBackgroundColour(image[1].transparentCol or image.backgroundCol)
    mon.clear()
    
    GIF.animateGIF(image)

end

main()