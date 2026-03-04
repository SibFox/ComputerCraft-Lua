-- Code by SibFox

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
---@param layer? number
local function addOption(name, func, layer)
    layer = layer or 1
    tOptions[layer][#tOptions[layer]+1] = { name = name, func = func }
end

addOption("Option 1", function ()
    print("Option 1 selected")
    sleep(1)
    return false
end)

addOption("Option 2", function ()
    print("Option 2 selected")
    sleep(1)
    return false
end)

addOption("Exit", function ()
    print("Exit option selected")
    sleep(1)
    return true
end)



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
        drawMenu("Terminal Name")
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