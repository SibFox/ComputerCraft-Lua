local term_add = require("terminal_additions")
local Set = require("set_lua").Set

-- local oldPullEvent = os.pullEvent

local payloadProtocol = "admin_spawn_drop_pod_loot"
local payloadSecret = "aRSnzS"

term_add.clearTerm()

local modem = peripheral.find("modem", function (name, modem)
    return modem.isWireless()
end) or error("> No modem attached!", 0)

rednet.open(peripheral.getName(modem))
if not rednet.isOpen() then
    term_add.exit("Couldn't establish connection! Rednet is not online.", true)
end

local pd = peripheral.find("player_detector")

settings.load("adm/sdpl/settings.adm")

local function getGiftedPlayersSetting() return settings.get("adm_sdpl_giftedplayers", nil) end
local function getEnergySetting() return settings.get("adm_sdpl_energy", nil) end

local function defineGiftedPlayersSetting()
    if getGiftedPlayersSetting() == nil then
        settings.define("adm_sdpl_giftedplayers", {
            description = "Gifted players",
            default = Set.new({}),
            type = "table"
        })
        -- print("[ADM] Gifted players setting defined")
    end
end

local function defineEnergySetting()
    if getEnergySetting() == nil then
        settings.define("adm_sdpl_energy", {
            description = "Energy",
            default = 86400, -- 24h
            type = "number"
        })
        -- print("[ADM] Energy setting defined")
    end
end

local function decrementEnergySetting(int)
    defineEnergySetting()
    settings.set("adm_sdpl_energy", getEnergySetting()-int)
    settings.save("adm/sdpl/settings.adm")
end

---@param player string
local function addToSettingGiftedPlayers(player)
    if type(player) == "string" then
        defineGiftedPlayersSetting()

        setGP = getGiftedPlayersSetting()
        if Set.contains(setGP, player) then
            return false
        end

        Set.add(setGP, player)
        settings.set("adm_sdpl_giftedplayers", setGP)
        settings.save("adm/sdpl/settings.adm")
        -- print("[ADM] Host specification is set to '"..spec.."'")
        return true
    else
        -- printError("[ADM] Player should be a string")
        return false
    end
end



if modem and pd then

    function giftStarterLoot(player)
        decrementEnergySetting(1000)
        if not addToSettingGiftedPlayers(player) then
            term.setTextColor(colors.magenta)
            print(player..", you already got your Survival Kit")
            sleep(5)
            return
        end

        local payload = {
            nickname = player,
            secret = payloadSecret
        }
        rednet.send(0, payload, payloadProtocol)

        term.setTextColor(colors.magenta)
        print(player.." granted Survival Kit")
        sleep(5)
    end

    function writeTerminal()
        term_add.clearTerm()
        term.setTextColor(colors.red)
        term_add.writeCenter("====== EMERGENCY SITUATION ======")
        print()
        print("Drop Pod suffered a hard landing!")
        term.setTextColor(colors.white)
        write("Planet of destination: ")
        term.setTextColor(colors.red)
        print("Unknown")
        term.setTextColor(colors.white)
        write("Drop Pod damage: ")
        term.setTextColor(colors.red)
        print("Severe")
        term.setTextColor(colors.white)
        write("Surviving crew: ")
        term.setTextColor(colors.red)
        print("Unknown")
        term.setTextColor(colors.white)
        write("Days since landing: ")
        term.setTextColor(colors.yellow)
        print("4")
        term.setTextColor(colors.white)
        write("Energy left: ")
        term.setTextColor(colors.yellow)
        print(getEnergySetting())
        term.setTextColor(colors.white)
        write("Survival Kit: ")
        term.setTextColor(colors.green)
        print("Intact")
        term.setTextColor(colors.white)
        print("You may request one Survival Kit")
        print("Click Detector below the Terminal")
    end
    defineEnergySetting()
    while true do
        if getEnergySetting() < 1 then
            local payload = {
                shutdown = true,
                secret = payloadSecret
            }
            rednet.send(0, payload, payloadProtocol)
            os.shutdown()
        end
        writeTerminal()
        parallel.waitForAny(function()
            local evt, username, _
            repeat
                evt, username, _ = os.pullEvent("playerClick")
            until evt == "playerClick"
            giftStarterLoot(username)
        end,
        function()
            sleep(1)
            decrementEnergySetting(1)
        end)
    end
else
    print("Necessery peripherals not found")
end