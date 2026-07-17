local sl = peripheral.wrap("left")
local sr = peripheral.wrap("right")

if sl and sr then
    os.pullEvent = os.pullEventRaw
    shell.run("rom/nzs_cover/exterminal.lua")
    while true do
        sl.playNote("bit", 1, 16)
        sr.playNote("bit", 0.7, 8)
        sleep(0.25)
    end
end