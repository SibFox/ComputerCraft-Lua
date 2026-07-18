local payloadProtocol = "admin_spawn_drop_pod_loot"
local payloadSecret = "aRSnzS"

local modem = peripheral.find("modem", function (name, modem)
    return modem.isWireless()
end) or error("> No modem attached!", 0)

rednet.open(peripheral.getName(modem))
if not rednet.isOpen() then
    term_add.exit("Couldn't establish connection! Rednet is not online.", true)
end

while true do
    local id, payload
    repeat
        id, payload = rednet.receive(payloadProtocol)
    until payloadSecret == payload.secret
    if payload["nickname"] ~= nil then
        print("Gifting items to "..payload.nickname)
        commands.give(payload.nickname.." minecraft:stone_axe[damage="..math.random(80, 100).."]")
    elseif payload.shutdown then
        commands.exec("setblock -234 72 33 minecraft:air")
        commands.exec("setblock -234 61 35 minecraft:air")
        sleep(1)
        os.shutdown()
    end
end