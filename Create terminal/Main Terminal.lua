-- Code by SibFox

local term_add = require("terminal_additions")
local switch_lib = require("switch_lib")
local switch = switch_lib.switch
local case = switch_lib.case
local default = switch_lib.default

local payloadProtocol = "nzi_p_minigoma_motor_setting"

term_add.clearTerm()

local modem = peripheral.find("modem", function (name, modem)
    return modem.isWireless()
end) or error("> No modem attached!", 0)

rednet.open(peripheral.getName(modem))
if not rednet.isOpen() then
    term_add.exit("Couldn't establish connection! Rednet is not online.", true)
end

local tOptions = {}
local iSelectedOption = 1
local iLayerDepth = 0
local bUpdateMonitor = true

local function selectionUp()
    iSelectedOption = iSelectedOption - 1
    if iSelectedOption < 1 then
        iSelectedOption = #tOptions[iLayerDepth]
    end
end

local function selectionDown()
    iSelectedOption = iSelectedOption + 1
    if iSelectedOption > #tOptions[iLayerDepth] then
        iSelectedOption = 1
    end
end

local function makeSelection()
    return tOptions[iLayerDepth][iSelectedOption].func()
end



----- Build options section

---@param name string
---@param func function
---@param layer number
---@param onInitFunc? function
local function addOption(name, func, layer, onInitFunc)
    if layer < 0 then layer = 0 end
    tOptions[layer] = tOptions[layer] or {}
    tOptions[layer][#tOptions[layer]+1] = { name = name, func = func }
    if onInitFunc ~= nil then
        onInitFunc()
    end
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

---@param module string
---@param line string
---@param spec string
---@param layer number
local function addOptionWithChangingNameOnPayload(module, line, spec, layer)
    local getStatePayload = function()
        local payload = {
            to = spec,
            task = { name = "getstate" }
        }
        rednet.broadcast(payload, payloadProtocol)
        local _, answer = rednet.receive(payloadProtocol, 5)
        switch(answer,
            case(0, function () changeOptionName(layer, iSelectedOption, line.." -> Disabled") end),
            case("active", function () changeOptionName(layer, iSelectedOption, line.." -> Enabled") end ),
            default(function ()
                term_add.exit("Connection to ".. module .." ".. line .." motor is not established")
                sleep(1)
            end)
        )
    end

    local sendStateChangePayload = function ()
        getStatePayload()
        local payload = {
            to = spec,
            task = { name = "stop" }
        }
        if string.find(tOptions[layer][iSelectedOption].name, "Disabled") then
            payload.task = "reactivate"
        end
        rednet.broadcast(payload, payloadProtocol)
        local _, answer = rednet.receive(payloadProtocol, 5)
        switch(answer.task.name,
            case("disable", function () changeOptionName(layer, iSelectedOption, line.." -> Disabled") end),
            case("activate", function () changeOptionName(layer, iSelectedOption, line.." -> Enabled") end )
        )
    end

    addOption(line.. " -> No connection", sendStateChangePayload, layer, getStatePayload)
end

-- Main terminal
addOption("Room modules control", function ()
    iLayerDepth = 1
    iSelectedOption = 1
    print("Room modules selected")
end, 0)

addOption("Elevator contorls", function ()
    iLayerDepth = 2
    iSelectedOption = 1
    print("Elevator controls selected")
end, 0)

addOption("Exit", function ()
    return true
end, 0)

-- 1 - Room modules
addOption("Overall module", function ()
    iLayerDepth = 1.1
    iSelectedOption = 1
    print("Overall room selected")
end, 1)

addOption("Crushing module", function ()
    iLayerDepth = 1.2
    iSelectedOption = 1
    print("Crushing room selected")
end, 1)

addOption("Experience module", function ()
    iLayerDepth = 1.3
    iSelectedOption = 1
    print("Experience room selected")
end, 1)

addOption("Back", function ()
    iLayerDepth = 0
    iSelectedOption = 1
end, 1)

-- 1.1 - Overall module
addOptionWithChangingNameOnPayload("Overall", "Main Line", "overall_main", 1.1)
addOptionWithChangingNameOnPayload("Overall", "Generic Machines", "overall_generic", 1.1)
addOptionWithChangingNameOnPayload("Overall", "Mechanical Crafter", "overall_crafter", 1.1)

addOption("Back", function ()
    iLayerDepth = 1
    iSelectedOption = 1
end, 1.1)

-- 1.2 - Crushing module
addOptionWithChangingNameOnPayload("Crushing", "Module", "crushing_main", 1.2)

addOption("Back", function ()
    iLayerDepth = 1
    iSelectedOption = 1
end, 1.2)

-- 1.3 - Experience module
addOptionWithChangingNameOnPayload("Experience", "Module", "experience_main", 1.3)

addOption("Back", function ()
    iLayerDepth = 1
    iSelectedOption = 1
end, 1.3)

-- 2 - Elevator controls
addOption("Back", function ()
    iLayerDepth = 0
    iSelectedOption = 1
end, 2)



-- Terminal section

---@param title string
---@param layer? number
local function drawMenu(title, layer)
    if layer < 0 then layer = 0 end
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
        bUpdateMonitor = false
        term_add.clearTerm()
        local termName = switch(iLayerDepth,
            case(1, function() return "Room modules control" end),
            case(1.1, function() return "Overall module" end),
            case(1.2, function() return "Crushing module" end),
            case(1.3, function() return "Experience module" end),
            case(2, function() return "Elevator controls" end),
            default(function() return "Control Panel" end)
        )
        drawMenu(termName, iLayerDepth)
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