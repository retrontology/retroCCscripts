local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")

local file = arg[1]
local volume = tonumber(arg[2])

local decoder = dfpwm.make_decoder()
for chunk in io.lines(file, 16 * 1024) do
    local buffer = decoder(chunk)

    while not speaker.playAudio(buffer, volume) do
        os.pullEvent("speaker_audio_empty")
    end
end