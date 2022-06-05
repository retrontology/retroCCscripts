function main()
    local file = arg[1]
    local volume = tonumber(arg[2])
    loop(file, volume)
end

function play(file, volume)
    local dfpwm = require("cc.audio.dfpwm")
    local speaker = peripheral.find("speaker")

    local decoder = dfpwm.make_decoder()
    for chunk in io.lines(file, 16 * 1024) do
        local buffer = decoder(chunk)

        while not speaker.playAudio(buffer, volume) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end

function loop(file, volume)
    local dfpwm = require("cc.audio.dfpwm")
    local speaker = peripheral.find("speaker")

    local decoder = dfpwm.make_decoder()
    local lines = io.lines(file, 16 * 1024)

    local data = {}
    local count = 0
    for chunk in lines do
        data[count] = decoder(chunk)
        count = count + 1
    end
    
    while true do
        for chunk in data do
            while not speaker.playAudio(buffer, volume) do
                os.pullEvent("speaker_audio_empty")
            end
        end
    end
end

main()