local term_add = require("terminal_additions")

local args = { ... }

local connectionProtocol, connectionHost = "nziA_p_door_crypt", "nziA_h_door_crypt_A"
local specification = "door_test"
local password = "door"

term_add.clearTerm()

local m = peripheral.find("modem") or error("> No modem attached!", 0)

rednet.open(peripheral.getName(m))
if not rednet.isOpen() then
    term_add.exit("> Couldn't establish connection! Rednet is not online.", true)
end

rednet.host(connectionProtocol.."_"..specification, connectionHost)
print(">> Host established")
print("> Host:          "..connectionHost)
print("> Protocol:      "..connectionProtocol)
print("> specification: "..specification)

local function workState()
    while true do
        local id, message
        repeat
            id, message = rednet.receive(connectionProtocol.."_"..specification)
        until #message > 0
        write("Door lock "..id.." send message: "..message.." > ")
        sleep(1)
        if message == password then
            print("Correct")
            rednet.send(id, true, connectionProtocol.."_"..specification)
        else
            print("Wrong")
            rednet.send(id, false, connectionProtocol.."_"..specification)
        end
    end 
end

function expectArgs()
    -- if #args <= 0 then
    --     showHelp()
    -- end
    if #args >= 1 and args[1] == "run" then
        workState()
    -- elseif #args >= 1 and args[1] == "help" then
    --     showHelp()
    -- elseif #args >= 1 then
    --     showHelp()
    end
end


expectArgs()