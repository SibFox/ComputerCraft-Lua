local connectionProtocol, connectionHost = "nziA_p_door_crypt", "nziA_h_door_crypt_A"
local specification = "door_test"
local password = "door"

local function clearTerm()
    term.clear()
    term.setCursorPos(1,1)
end

clearTerm()

rednet.open("modem") -- side?...
if not rednet.isOpen() then
    exit("> Couldn't establish connection! Rednet is not online.", true)
end

rednet.host(connectionProtocol.."_"..specification, connectionHost)
print("> Host established")

while true do
    local id, message
    repeat
        id, message = rednet.receive(connectionProtocol.."_"..specification)
    until #message > 0
    write("Door lock "..id.." send message: "..message.." > ")
    sleep(1)
    if message == password then
        write("Correct\n")
        rednet.send(id, true, connectionProtocol.."_"..specification)
    else
        print("Wrong\n")
        rednet.send(id, false, connectionProtocol.."_"..specification)
    end
end