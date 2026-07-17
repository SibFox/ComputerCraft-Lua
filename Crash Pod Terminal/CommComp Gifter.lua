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
    print("Gifting items to "..payload.nickname)
    commands.give(payload.nickname.." minecraft:stone_axe[damage="..math.random(80, 100).."]")
end