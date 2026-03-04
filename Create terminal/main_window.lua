-- Code by SibFox
-- main_window.lua

local siblib = require("siblib")
local switch = siblib.switch
local case = siblib.case
local default = siblib.default

local tOptions = {}
local iSelectedOption = 1
local iLayerDepth = 1
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



------ Build options section

---@param name string
---@param func function
---@param layer? number
local function addOption(name, func, layer)
    layer = layer or 1
    tOptions[layer] = tOptions[layer] or {}
    tOptions[layer][#tOptions[layer]+1] = { name = name, func = func }
end

-- Main terminal
addOption("Room modules control", function ()
    iLayerDepth = 2
    print("Room modules selected")
    sleep(1)
end, 1)

addOption("Elevator contorls", function ()
    iLayerDepth = 3
    print("Elevator controls selected")
    sleep(1)
end, 1)

addOption("Exit", function ()
    return true
end, 1)

-- Room modules
addOption("Overall room", function ()
    iLayerDepth = 21
    print("Overall room selected")
    sleep(1)
end, 2)

addOption("Crushing room", function ()
    iLayerDepth = 1--22
    print("Crushing room selected")
    sleep(1)
end, 2)

addOption("Experience room", function ()
    iLayerDepth = 23
    print("Experience room selected")
    sleep(1)
end, 3)

addOption("Back", function ()
    iLayerDepth = 1
    print("Back selected")
    sleep(1)
end, 3)


-- Terminal section

---@param title string
---@param layer? number
local function drawMenu(title, layer)
    layer = layer or 1
    siblib.writeCenter("---- ["..title.."] ----")
    term.setTextColor(colors.white)
    for i=1, #tOptions[layer] do
        if iSelectedOption == i then
            write(">>\t")
        else
            write("  \t")
        end
        print(tOptions[layer][i].name)
    end
    siblib.writeCenter("---- ["..string.rep("=", #title).."] ----")
end

while true do

    if bUpdateMonitor then
        siblib.clearTerm()
        local termName = switch(iLayerDepth,
            case(2, function() return "Room modules control" end),
            case(3, function() return "Elevator controls" end),
            default(function() return "Control Panel" end)
        )
        drawMenu(termName, iLayerDepth)
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

siblib.printTable(tOptions)