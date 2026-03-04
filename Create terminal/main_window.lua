-- Code by SibFox
-- main_window.lua

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

addOption("Room modules control", function ()
    os.run({}, "rom/nez_inc/control_terminal/room_modules_window.lua")
    print("Option 1 selected")
    sleep(1)
    return false
end)

addOption("Elevator contorls", function ()
    -- os.run({}, "rom/nez_inc/control_terminal/elevator_window.lua")
    print("Elevator controls selected")
    sleep(1)
    return false
end)

addOption("Exit", function ()
    print("Exit option selected")
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