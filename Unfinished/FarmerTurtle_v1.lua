-- Farmer Turtle settings and work v1
-- Code by SibFox

local tOptions = {
    "Wheat",
    "Carrot",
    "Potato",
    "Cabbage",
    "Onion",
    "Tomato"
}

local tPlantData = {
    ["Wheat"] = { Name = "minecraft:wheat", Block = "minecraft:wheat", Seeds = "minecraft:wheat_seeds", MaxAge = 7 },
    ["Carrot"] = { Name = "minecraft:carrot", Block = "minecraft:carrots", Seeds = "minecraft:carrot", MaxAge = 7 },
    ["Potato"] = { Name = "minecraft:potato", Block = "minecraft:potatoes", Seeds = "minecraft:potato", MaxAge = 7 },
    ["Cabbage"] = { Name = "farmersdelight:cabbage", Block = "farmersdelight:cabbages", Seeds = "farmersdelight:cabbage_seeds", MaxAge = 7 },
    ["Onion"] = { Name = "farmersdelight:onion", Block = "farmersdelight:onions", Block = "farmersdelight:", Seeds = "farmersdelight:onion", MaxAge = 7 },
    ["Tomato"] = { Name = "farmersdelight:tomato", Block = "farmersdelight:tomatoes", Seeds = "farmersdelight:tomato_seeds", MaxAge = 3 }
}

local tBlockData = {
    ["minecraft:wheat"] = "Wheat",
    ["minecraft:carrots"] = "Carrot",
    ["minecraft:potatoes"] = "Potato",
    ["minecraft:cabbages"] = "Cabbage",
    ["minecraft:onions"] = "Onion",
    ["minecraft:tomatoes"] = "Tomato"
}

local iSelectedOption, iWorkingLoop = 1, 1
local bUpdateMonitor = true

local function clearTerm(posX, posY)
    term.clear()
    term.setCursorPos(posX, posY)
end

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

local function checkForSeedsAndCoal()
    print("> Then press to continue")
    print("> Turtle will plant seeds on empty farmland and coal to continue working")
    io.read()
    if type(turtle.getItemDetail(1)) ~= "nil" then
        if turtle.getItemDetail(1).name == tPlantData[tOptions[iSelectedOption]].Seeds then
            write("Seeds accepted")
        else
            clearTerm(1,1)
            print("wrn> Not a "..tOptions[iSelectedOption].." seeds...\n")
            return false
        end
    else
        clearTerm(1,1)
        print("err> No seeds provided...\n")
        return false
    end
    if type(turtle.getItemDetail(16)) ~= "nil" then
        if turtle.getItemDetail(16).name == "minecraft:coal" or turtle.getItemDetail(16).name == "minecraft:charcoal" then
            return true
        else
            clearTerm(1,1)
            print("wrn> Put coal or charcoal into second slot...\n")
            return false
        end
    else
        clearTerm(1,1)
        print("err> No fuel provided...\n")
        return false
    end
    return false
end

local function optionWheat()
    clearTerm(1,1)
    while true do
        print("> Put wheat seeds into first slot and coal into last")
        if checkForSeedsAndCoal() then
            return true
        end
    end
end

local function optionCarrot()
    clearTerm(1,1)
    while true do
        print("> Put carrot into first slot and coal into last")
        if checkForSeedsAndCoal() then
            return true
        end
    end
end

local function optionPotato()
    clearTerm(1,1)
    while true do
        print("> Put potato into first slot and coal into last")
        if checkForSeedsAndCoal() then
            return true
        end
    end
end

local function optionCabbage()
    clearTerm(1,1)
    while true do
        print("> Put cabbage seeds into first slot and coal into last")
        if checkForSeedsAndCoal() then
            return true
        end
    end
end

local function optionOnion()
    clearTerm(1,1)
    while true do
        print("> Put onion into first slot and coal into last")
        if checkForSeedsAndCoal() then
            return true
        end
    end
end

local function optionTomato()
    clearTerm(1,1)
    while true do
        print("> Put tomato seeds into first slot and coal into last")
        if checkForSeedsAndCoal() then
            return true
        end
    end
end

local function makeSelection()
    if iSelectedOption == 1 then
        return optionWheat()
    elseif iSelectedOption == 2 then
        return optionCarrot()
    elseif iSelectedOption == 3 then
        return optionPotato()
    elseif iSelectedOption == 4 then
        return optionCabbage()
    elseif iSelectedOption == 5 then
        return optionOnion()
    elseif iSelectedOption == 6 then
        return optionTomato()
    end
end

local iFarmLength, iFarmWidth

clearTerm(1,1)

while true do
    print("> Welcome to FarmerTurtle v1 settings!\n")
    print("> Put turtle in the left down corner of a farm one block above ground")
    print("> Put chest left to the turtle on the ground")
    print("> Specify length and width of a farm from that point")
    write("> Length (Forward from turtle): ")
    iFarmLength = tonumber(io.read())
    write("> Width (Right from turtle): ")
    iFarmWidth = tonumber(io.read())
    if type(iFarmLength) ~= "number" or type(iFarmWidth) ~= "number" then
        clearTerm(1,1)
        print("err> Should be number\n\n")
    else
        if iFarmLength < 1 or iFarmWidth < 1 then
            clearTerm(1,1)
            print("err> Must be more or equal to 1\n\n")
        elseif iFarmLength * iFarmWidth > 50 then
            clearTerm(1,1)
            print("err> Maximum planation size is 50")
            print("Yours is ".. tostring(iFarmLength * iFarmWidth).."\n\n")
        else
            break
        end
    end
end

iFarmLength = math.floor(iFarmLength)
iFarmWidth = math.floor(iFarmWidth)

print("\n> Length and width scpecified to: "..tostring(iFarmLength).." & "..tostring(iFarmWidth))
print("> Next settings are for plant")
print("> Press any key to continue")
io.read()


while true do
    if bUpdateMonitor then
        clearTerm(1,1)
        print(">--Turtle works with this settings until reboot--<")
        print("Use Arrow Keys to select and Enter to confirm")
        print("Select what plant you want to grow")
        for i=1, #tOptions do
            if iSelectedOption == i then
                write(">>\t")
            end
            print(tOptions[i])
        end
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
                break
            end
            iSelectedOption = 1
            bUpdateMonitor = true
        end
    end
end

local function getPlantData()
    return tPlantData[tOptions[iSelectedOption]]
end

while true do
    bUpdateMonitor = true
    local bMessageRefueled, bMessageNoFuel = true, true

    if bUpdateMonitor then
        clearTerm(1,1)
        print(">> Settings Applied:")
        print("> Farm Length/Width -> "..tostring(iFarmLength).."/"..tostring(iFarmWidth))
        print("> Chosen plant -> "..tOptions[iSelectedOption])
        print("Working... Loop - "..tostring(iWorkingLoop))
    end

    for w = 1, iFarmWidth do
        for l = 1, iFarmLength do
            local bSuccess, tData = turtle.inspectDown()
            if bSuccess then
                if tData.state.age == getPlantData().MaxAge then
                    turtle.digDown()
                    turtle.suckDown()
                else
                    print("inf> Not a grown plant. Age "..tostring(tData.state.age).. " of max "..tostring(getPlantData().MaxAge))
                end
                if turtle.getItemDetail().name == getPlantData().Seeds then
                    if turtle.getItemCount() > 1 then
                        turtle.placeDown()
                    else
                        print("inf> Turtle will always leave 1 seed")
                    end
                else
                    print("wrn> First slot doesn't contain seeds")
                end
            else
                print("wrn> Space below is empty")
            end
            while turtle.getFuelLevel() < 1 do
                if turtle.refuel(1) then
                    if bMessageRefueled then
                        print("inf> Successfuly refueled")
                    end
                else
                    if bMessageNoFuel then
                        print("inf> Turtle can't move -> No fuel")
                    end
                end
            end
            if l ~= iFarmLength then
                turtle.forward()
            end
        end
        print("tst> Length Loop Over")
        sleep(2)
        break
    end
    iWorkingLoop = iWorkingLoop + 1
    sleep(10)
end

