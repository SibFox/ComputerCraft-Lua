-- Code by SibFox

local switch_lib = require("switch_lib")
local term_add = require("terminal_additions")

local switch = switch_lib.switch
local case = switch_lib.case
local default = switch_lib.default

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
    return tOptions[iLayerDepth][iSelectedOption].func()
end

-- Peripheral registering
-- local motorOverallMainLine = peripheral.find("motor")


----- Build options section

---@param name string
---@param func function
---@param layer number
---@param onInitFunc? function
local function addOption(name, func, layer, onInitFunc)
    if onInitFunc ~= nil then
        onInitFunc()
    end
    if layer < 0 then layer = 0 end
    tOptions[layer] = tOptions[layer] or {}
    tOptions[layer][#tOptions[layer]+1] = { name = name, func = func }
end

---@param layer number
---@param index number
---@param to string
local function changeOptionName(layer, index, to)
    local from = tOptions[layer][index]
    if from ~= nil then
        from.name = to
    end
end

-- Main terminal
addOption("Room modules control", function ()
    iLayerDepth = 1
    print("Room modules selected")
end, 0)

addOption("Elevator contorls", function ()
    iLayerDepth = 2
    print("Elevator controls selected")
end, 0)

addOption("Exit", function ()
    return true
end, 0)

-- Room modules
addOption("Overall module", function ()
    iLayerDepth = 11
    print("Overall room selected")
end, 1)

addOption("Crushing module", function ()
    iLayerDepth = 12
    print("Crushing room selected")
end, 1)

addOption("Experience module", function ()
    iLayerDepth = 13
    print("Experience room selected")
end, 1)

addOption("Back", function ()
    iLayerDepth = 0
end, 1)

-- 2.1 - Overall module
addOption("Main line", function ()
    changeOptionName(11, 1, "Main line - Disabled")
end, 11)

-- Terminal section

---@param title string
---@param layer? number
local function drawMenu(title, layer)
    layer = layer or 1
    print("---- ["..title.."] ----")
    term.setTextColor(colors.white)
    for i=1, #tOptions[layer] do
        if iSelectedOption == i then
            write(">>\t")
        else
            write("  \t")
        end
        print(tOptions[layer][i].name)
    end
    print("---- ["..string.rep("=", #title).."] ----")
end

while true do

    if bUpdateMonitor then
        term_add.clearTerm()
        local termName = switch(iLayerDepth,
            case(1, function() return "Room modules control" end),
            case(2, function() return "Elevator controls" end),
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
                term_add.clearTerm()
                break
            end
            bUpdateMonitor = true
        end
    end

end