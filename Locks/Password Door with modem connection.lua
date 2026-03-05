local term_add = require("terminal_additions")

local version = "A.1"
local connectionProtocol, connectionHost = "nziA_p_door_crypt", "nziA_h_door_crypt_A"
local specification = "door_test"
local localID = os.getComputerID()
local hostID = nil
local termiantionPass = "nzi_sf_jk_trpss"

local function defineVersion()
    if type(settings.get("nzi_pd_startup_version")) == nil then
        settings.define("nzi_pd_startup_version", {
            description = "",
            default = version,
            type = "string"
        })
    end
end

defineVersion()

term_add.clearTerm()

local m = peripheral.find("modem", rednet.open) or error("> No modem attached!", 0)
local rl = peripheral.find("redstone_relay") or error("> No redstone relay attached!", 0)

-- rednet.open("modem_0")
if not rednet.isOpen() then
    exit("> Couldn't establish connection! Rednet is not online.", true)
end


while true do
    local enteredPass = ""
    local answer = false
    repeat
        term_add.clearTerm()
        hostID = hostID == nil and rednet.lookup(connectionProtocol.."_"..specification, connectionHost) or hostID
        if hostID == nil then
            printError("> Unnable to find crypt host! Termination password is the only available.")
        end
        write("> Enter password: ")
        enteredPass = io.read()
        if hostID ~= nil then
            rednet.send(hostID, enteredPass, connectionProtocol.."_"..specification)
            local connections = 0
            local _, y = term.getCursorPos()
            while connections < 5 do
                _, answer = rednet.receive(connectionProtocol.."_"..specification, 3)
                if answer then
                    break
                end
                connections = connections + 1
                term.setCursorPos(1, y)
                print("> Attempt to connect "..connections.."...")
            end
            if connections >= 5 then
                hostID = nil
                term_add.exit("Connection have not been established")
            end
        else
            if enteredPass == termiantionPass then
                term_add.exit()
            end
        end
    until answer == true
    print("> Lock unlocked.")
    rl.setAnalogOutput("bottom", 15)
    sleep(3)
    rl.setAnalogOutput("bottom", 0)
    term_add.clearTerm()
end
