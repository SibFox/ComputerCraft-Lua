-- Code by SibFox

local term_add = require("terminal_additions")
local siblib = require("siblib")
local switch_lib = require("switch_lib")
local switch = switch_lib.switch
local case = switch_lib.case
local default = switch_lib.default

local connectionProtocol, connectionHost = "nzi_p_minigoma_motor_setting", "nzi_h_minigoma_motor_setting"
local sSettingSpecification = "nzi_mh_specification"
local sSettingMotorSpeed = "nzi_mh_motor_speed"
local sSettingsPath = "nzi/mh/settings.nzi"

local bUnhosted = true
local bUpdateScreen = true

term_add.clearTerm()

local modem = peripheral.find("modem", function (name, modem)
    rednet.open(name)
    return modem.isWireless()
end) or error("> No modem attached!", 0)

local motor = peripheral.find("electric_motor", function (name, motor)
    iMotorSpeed = motor.getSpeed()
    return true
end) or error("> No electric motor attached!", 0)

if not rednet.isOpen() then
    term_add.exit("Couldn't establish connection! Rednet is not online.", true)
end

settings.load(sSettingsPath)

local function getSpecification() return settings.get(sSettingSpecification, nil) end
local function getSettingMotorSpeed() return settings.get(sSettingMotorSpeed, nil) end

local function defineSpecificationSetting()
    if getSpecification() == nil then
        settings.define(sSettingSpecification, {
            description = "Motor host specification",
            default = "",
            type = "string"
        })
        print("[MH_NZI] Specification setting defined")
    end
end

local function defineMotorSpeedSetting()
    if getSettingMotorSpeed() == nil then
        settings.define(sSettingMotorSpeed, {
            description = "Motor speed",
            default = "",
            type = "number"
        })
        print("[MH_NZI] Motor speed setting defined")
    end
end

---@param spec string
local function setSettingSpecification(spec)
    if type(spec) == "string" then
        defineSpecificationSetting()
        settings.set(sSettingSpecification, spec)
        settings.save(sSettingsPath)
        print("[MH_NZI] Host specification is set to '"..spec.."'")
        return true
    else
        printError("[MH_NZI] Specification should be a string")
        return false
    end
end

---@param speed number
local function setSettingMotorSpeed(speed)
    if type(speed) == "number" then
        defineMotorSpeedSetting()
        settings.set(sSettingMotorSpeed, speed)
        settings.save(sSettingsPath)
        -- print("[MH_NZI] Motor speed is set to '"..speed.."'")
        return true
    else
        printError("[MH_NZI] Motor speed should be a number")
        return false
    end
end

local function establishHost()
    if bUnhosted then
        defineSpecificationSetting()
        local specification = getSpecification()
        if string.len(specification) == 0 or specification == nil then
            print("> Host specification is not defined")
            write("> Define specification: ")
            if not setSettingSpecification(io.read()) then
                term_add.exit("Couldn't establish host! Exiting from program...", true)
            end
        end
        rednet.host(connectionProtocol, connectionHost.."_"..specification)
        return true
    end
    return true
end

local function setCursorToInput()
    x, _ = term.getSize()
    for i = 9, x do
        term.setCursorPos(i, 10)
        write(" ")
        term.setCursorPos(i-9, 11)
        write(" ")
    end
    for i = x-9, x do
        term.setCursorPos(i, 11)
        write(" ")
    end
    term.setCursorPos(10, 10)
end

local function setCursorToLog()
    x, y = term.getSize()
    for i = 1, x do
        for j = 13, y do
            term.setCursorPos(i, j)
            write(" ")
        end
    end
    term.setCursorPos(1, 13)
end

---@param message string
local function writeToLog(message)
    setCursorToLog()
    print(message)
    setCursorToInput()
end

local function drawTerminal()
    term_add.clearTerm()
    term.setTextColor(colors.lightGray)
    print("---- [Motor Terminal] ----")
    term.setTextColor(colors.white)
    print("> Specification -> ".. getSpecification())
    print("> Speed -> ".. motor.getSpeed())
    print("> Command Pallette")
    print("- respecify <string> - new spec name")
    print("- setspeed <num> - set new speed")
    print("- stop - stops motor")
    print("- reactivate - start motor with previous speed")
    term.setTextColor(colors.lightGray)
    print("---- [==============] ----")
    term.setTextColor(colors.white)
    print("Command: ")
    print("\nLast output:")
    setCursorToInput()
end

---@param speed number
local function writeSpeed(speed)
    motorSpeed = speed
    motor.setSpeed(motorSpeed)
    term.setCursorPos(12, 3)
    write("    ")
    term.setCursorPos(12, 3)
    if motorSpeed == 0 then
        motorSpeed = "Stopped"
    end
    write(motorSpeed)
end

---@param speed number
local function setMotorSpeed(speed)
    speed = siblib.clamp(speed, -256, 256)
    writeSpeed(speed)
    setSettingMotorSpeed(speed)
    writeToLog("Motor speed changed to ".. speed)
end

---@param comp_id? number
local function stopMotor(comp_id)
    writeSpeed(0)
    writeToLog("Motor stopped")
    if comp_id ~= nil then
        rednet.send(comp_id, { task = { name = "disable" } }, connectionProtocol)
    end
end

---@param comp_id? number
local function activateMotor(comp_id)
    local speed = getSettingMotorSpeed()
    writeSpeed(speed)
    writeToLog("Motor activated with speed ".. speed)
    if comp_id ~= nil then
        rednet.send(comp_id, { task = { name = "activate" } }, connectionProtocol)
    end
end

local function catchPayload()
    local id, payload
    repeat
        id, payload = rednet.receive(connectionProtocol)
    until payload.to == getSpecification()
    writeToLog("Payload catched with name '".. payload.task.name .."' to '".. payload.to .."'")
    switch(payload.task.name,
        case("stop", stopMotor, id),
        case("reactivate", activateMotor, id),
        case("setspeed", function ()
            setMotorSpeed(payload.task.value)
        end),
        case("getstate", function ()
            if motor.getSpeed() == 0 then
                if rednet.send(id, 0, connectionProtocol) then
                    writeToLog("Send message '0' to ".. id)
                    return
                end
                writeToLog("Couldn't send message '0' to ".. id)
                return
            end
            if rednet.send(id, "active", connectionProtocol) then
                writeToLog("Send message 'active' to ".. id)
                return
            end
            writeToLog("Couldn't send message 'active' to ".. id)
        end),
        default(function ()
            writeToLog("Unsuspected task from payload")
        end)
    )
end

local function awaitCommand()
    setCursorToInput()
    local insert = io.read()
    insert = string.lower(insert)
    local tInserts = siblib.splitstr(insert)
    switch(tInserts[1],
        case("respecify", function ()
            x, _ = term.getSize()
            if string.len(tInserts[2]) > x - 20 then
                writeToLog("Specification name is too long")
                return
            end
            rednet.unhost(connectionProtocol, connectionHost.."_"..getSpecification())
            bUnhosted = true
            setCursorToLog()
            setSettingSpecification(tInserts[2])
            establishHost()
            term.setCursorPos(20, 2)
            for i = 20, x do
                term.setCursorPos(i, 2)
                write(" ")
            end
            term.setCursorPos(20, 2)
            write(getSpecification())
        end),
        case("stop", stopMotor),
        case("reactivate", activateMotor),
        case("setspeed", function ()
            local num = tonumber(tInserts[2])
            if num ~= nil then
                setMotorSpeed(num)
            end
        end),
        default(function ()
            writeToLog("Unknown command")
        end)
    )
    -- bUpdateScreen = true
end

local function awaitSleep() sleep(10) end

if motor.getSpeed() ~= 0 then
    setSettingMotorSpeed(motor.getSpeed())
end

while true do

    establishHost()

    if bUpdateScreen then
        drawTerminal()
        bUpdateScreen = false
    end

    parallel.waitForAny(catchPayload, awaitCommand)

end