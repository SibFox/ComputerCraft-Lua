-- Code by SibFox

local switch_lib = require("switch_lib")
local term_add = require("terminal_additions")

local switch = switch_lib.switch
local case = switch_lib.case
local default = switch_lib.default

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

-- Лучше сделать через Rednet - и легко масштабируется и читаемей
-- Прослушка идёт по протоколу - соотвественно пэйлоуд должен быть таблицей
-- содержащей указатель, какой мотор и как будет задействован
-- Для этого нужно будет посылать бродкаст по конкретному протоколу

-- Однако не обязательно, так как хостить можно как по одному протоколу, так и по одному хосту
-- Задать протокол отвечающий за электро моторы, при лукапе он будет выдавать айди всех хостов
-- Хотя по этим айди не определить точно местоположения мотора, посему пейлоуд пока акутальнее

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

-- 1 - Room modules
addOption("Overall module", function ()
    iLayerDepth = 1.1
    print("Overall room selected")
end, 1)

addOption("Crushing module", function ()
    iLayerDepth = 1.2
    print("Crushing room selected")
end, 1)

addOption("Experience module", function ()
    iLayerDepth = 1.3
    print("Experience room selected")
end, 1)

addOption("Back", function ()
    iLayerDepth = 0
    iSelectedOption = 1
end, 1)

-- 1.1 - Overall module
addOption("Main line - Enabled", function ()
    changeOptionName(1.1, 1, "Main line - Disabled")
end, 1.1)

addOption("Back", function ()
    iLayerDepth = 1
    iSelectedOption = 1
end, 1.1)

-- 1.2 - Crushing module
addOption("Module - Enabled", function ()
    changeOptionName(1.2, 1, "Module - Disabled")
end, 1.2)

addOption("Back", function ()
    iLayerDepth = 1
    iSelectedOption = 1
end, 1.2)

-- 1.3 - Experience module
addOption("Module - Enabled", function ()
    changeOptionName(1.3, 1, "Module - Disabled")
end, 1.3)

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