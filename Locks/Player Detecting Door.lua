local term_add = require("terminal_additions")

local args = { ... }

local allowedUsers = { ... }

local function defineUsersSetting()
    if type(settings.get("nzi_upd_users")) == "nil" then
        settings.define("nzi_upd_users", {
            description = "Allowed users for protection",
            default = "",
            type = "string"
        })
        print("[UPD_NZI] Users setting defined")
    end
end

local function defineRedstoneSideSetting()
    if type(settings.get("nzi_upd_rs_side")) == "nil" then
        settings.define("nzi_upd_rs_side", {
            description = "Computer redstone side output",
            default = "bottom",
            type = "string"
        })
        print("[UPD_NZI] Redstone side output setting defined")
    end
end

local function defineRedstonePowerSetting()
    if type(settings.get("nzi_upd_rs_power")) == "nil" then
        settings.define("nzi_upd_rs_power", {
            description = "Computer redstone power output",
            default = 15,
            type = "number"
        })
        print("[UPD_NZI] Redstone power output setting defined")
    end
end

local function setRedstoneSide(side)
    if type(side) == "string" then
        defineRedstoneSideSetting()
        if side == "front" or side == "top" or side == "left" or side == "right" or side == "back" or side == "bottom" then
            settings.set("nzi_upd_rs_side", side)
            print("[UPD_NZI] Redstone side output is set to "..side)
            settings.save("nzi/upd/settings.nzi")
        else
            printError("[UPD_NZI] Wrong side declared")
        end
    else
        printError("[UPD_NZI] Side should be a string")
    end
end

local function setRedstonePower(power)
    power = tonumber(power)
    if type(power) == "number" then
        defineRedstonePowerSetting()
        if power >= 0 and power <= 15 then
            settings.set("nzi_upd_rs_power", power)
            print("[UPD_NZI] Redstone power output is set to "..power)
            settings.save("nzi/upd/settings.nzi")
        else
            printError("[UPD_NZI] Power should be >=0 and 15<=")
        end
    else
        printError("[UPD_NZI] Power should be a number")
    end
end

local function showHelp()
    term.setTextColor(colors.lightGray)
    print("---- [User Protected Door] ----")
    term.setTextColor(colors.white)
    print("uprdoor help              - Show this menu")
    print("uprdoor run               - Start protection")
    print("uprdoor add <username>    - Add user to protection system")
    print("uprdoor remove <username> - Remove user from protection system")
    print("uprdoor rm <username>     - Same as remove")
    print("uprdoor rs side <side>    - Set redstone side output")
    print("uprdoor rs power <num>    - Set redstone power output")
    term.setTextColor(colors.lightGray)
    print("---- [===================] ----")
    term.setTextColor(colors.white)
end

local function contains(tab, val)
    for i, v in ipairs(tab) do
        if v == val then
            return true, i
        end
    end

    return false
end

local function getAllowedUsers()
    usersSetting = settings.get("nzi_upd_users")
    users = {}
    if type(usersSetting) ~= "nil" then
        if #usersSetting > 0 then
            for user in string.gmatch(usersSetting, "%a+") do
            table.insert(users, user) 
            end
        end
    end
    return users
end

local function addUserInSetting(username)
    newUser = getAllowedUsers()
    table.insert(newUser, username)
    usersStr = table.concat(newUser,";")
    settings.set("nzi_upd_users", usersStr)
end

local function removeUserInSetting(index)
    users = getAllowedUsers()
    table.remove(users, index)
    usersStr = table.concat(users,";")
    settings.set("nzi_upd_users", usersStr)
end

local function addUser(username)
    if type(username) ~= "nil" then
        defineUsersSetting()
        if not contains(getAllowedUsers(), username) then
            addUserInSetting(username)
            print("User with name " .. username .. " is added to protection")
            settings.save("nzi/upd/settings.nzi")
        end
    else
        print("Username is nil")
    end
end

local function removeUser(username)
    if type(username) ~= "nil" then
        b, i = contains(getAllowedUsers(), username)
        if b then
            removeUserInSetting(i)
            print("User with name " .. username .. " is removed from protection")
            settings.save("nzi/upd/settings.nzi")
        end
    else
        print("Username is nil")
    end
end

local function doorCheck()
    defineRedstoneSideSetting()
    defineRedstonePowerSetting()
    term.clear()
    term.setCursorPos(1,1)
    settings.load("nzi/upd/settings.nzi")
    while true do
        local event, username, device = os.pullEvent("playerClick")
        print("Detected player with username " .. username)

        if contains(getAllowedUsers(), username) then
            print("Passed")
            redstone.setAnalogOutput(settings.get("nzi_upd_rs_side"), settings.get("nzi_upd_rs_power"))
            sleep(1.5)
            redstone.setAnalogOutput(settings.get("nzi_upd_rs_side"), 0)
        end
    end
end

local function users()
    settings.load("nzi/upd/settings.nzi")
    print(table.concat(getAllowedUsers(), ", "))
end

function expectArgs()
    if #args <= 0 then
        showHelp()
    end
    if #args >= 3 and args[1] == "rs" then
        if args[2] == "side" then
            setRedstoneSide(args[3])
        elseif args[2] == "power" then
            setRedstonePower(args[3])
        end
    elseif #args >= 2 and args[1] == "add" then
        addUser(args[2])
    elseif #args >= 2 and (args[1] == "remove" or args[1] == "rm") then
        removeUser(args[2])
    elseif #args >= 1 and args[1] == "run" then
        doorCheck()
    elseif #args >= 1 and args[1] == "users" then
        users()
    elseif #args >= 1 and args[1] == "help" then
        showHelp()
    elseif #args >= 1 then
        showHelp()
    end
end


expectArgs()