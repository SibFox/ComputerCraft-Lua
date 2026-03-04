-- Code by SibFox
-- room_modules_window.lua

local siblib = require("siblib")

local tOptions = {}
local iSelectedOption = 1
local bUpdateMonitor = true

local function selectionUp()
    iSelectedOption = iSelectedOption - 1
    if iSelectedOption < 1 then
        iSelectedOption = #tOptions
    end
end

local function selectionDown()
    iSelectedOption = iSelectedOption + 1
    if iSelectedOption > #tOptions then
        iSelectedOption = 1
    end
end

local function makeSelection()
    return tOptions[iSelectedOption].func()
end



-- Build options section

---@param name string
---@param func function
---@param level? number
local function addOption(name, func, level)
    level = level or 1
    tOptions[#tOptions+1] = { name = name, func = func }
end

addOption("Overall room", function ()
    os.run({}, "rom/nez_inc/control_terminal/overall_room/main_window.lua")
    print("Overall room chosen")
    sleep(1)
    return false
end)

addOption("Crushing room", function ()
    os.run({}, "rom/nez_inc/control_terminal/crushing_room/main_window.lua")
    print("Crushing room chosen")
    sleep(1)
    return false
end)

addOption("Experience room", function ()
    os.run({}, "rom/nez_inc/control_terminal/experience_room/main_window.lua")
    print("Experience room chosen")
    sleep(1)
    return false
end)

addOption("Elevator contorls", function ()
    print("Option 2 selected")
    sleep(1)
    return false
end)

addOption("Back", function ()
    print("Back option selected")
    sleep(1)
    return true
end)



-- Terminal section

while true do

    if bUpdateMonitor then
        siblib.clearTerm()
        siblib.writeCenter("---- [Control Terminal] ----")
        term.setTextColor(colors.lightGray)
        print("<< Arrows to select")
        print("<< Enter to confirm")
        term.setTextColor(colors.white)
        for i=1, #tOptions do
            if iSelectedOption == i then
                write(">>\t")
            else
                write("  \t")
            end
            print(tOptions[i].name)
        end
        siblib.writeCenter("---- [================] ----")
        bUpdateMonitor = false
    end

    local sEvent, input = os.pullEvent("key")
    if sEvent == "key" then
        if input == 265 then -- Arrow up
            selectionUp()
            bUpdateMonitor = true
        end
        if input == 264 then -- Arrow down
            selectionDown()
            bUpdateMonitor = true
        end
        if input == 257 then -- Enter
            if makeSelection() then
                siblib.clearTerm()
                break
            end
            bUpdateMonitor = true
        end
    end

end