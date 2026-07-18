local sl = peripheral.wrap("left")
local sr = peripheral.wrap("right")

settings.load("adm/sdpl/settings.adm")
local oldPullEvent = os.pullEvent

if sl and sr then
    os.pullEvent = os.pullEventRaw
    parallel.waitForAll(function ()
        shell.run("nzs_cover/exterminal.lua")
    end,
    function ()
        while true do
            local setting = settings.get("adm_sdpl_energy", nil)
            if setting ~= nil then
                if setting < 36000 then -- 10h
                    sl.playNote("pling", 0.7, 0)
                    sr.playNote("didgeridoo", 0.7, 0)
                    sleep(1.5)
                elseif setting < 72000 then -- 20h
                    sl.playNote("bit", 0.7, 16)
                    sr.playNote("bit", 0.7, 8)
                    sleep(0.75)
                elseif setting < 82800 then -- 23h
                    sl.playNote("bit", 1, 16)
                    sr.playNote("bit", 0.7, 8)
                    sleep(0.45)
                else
                    sl.playNote("bit", 1, 16)
                    sr.playNote("bit", 0.7, 8)
                    sleep(0.25)
                end
            else
                sl.playNote("bit", 1, 16)
                sr.playNote("bit", 0.7, 8)
                sleep(0.25)
            end
        end
    end)
end