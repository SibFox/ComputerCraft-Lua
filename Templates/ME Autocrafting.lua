bridge = peripheral.find("me_bridge")

resources = {
    { name = "Silicon crystal", res_name = "industrialupgrade:crafting_elements/crafting_493_element", type = "item" }
}


function checkMe(toCraft)
    isCraftable = bridge.isCraftable({ name = toCraft.res_name, type = toCraft.type })
    if not isCraftable then
        print("Is not craftable " .. toCraft.name)
    end

    local resource = nil

    if toCraft.name == "Silicon crystal" then
        resource = bridge.getItem({ name = "industrialupgrade:crafting_elements/crafting_492_element", type = "item" })
    end

    if not resource then
        size = 0
    else
        size = resource.count
    end

    local isCrafting = bridge.isCrafting({name = toCraft.res_name, type = toCraft.type})

    if not isCrafting then
            --Prepare the table for "craftItem"
            local filter = {name = toCraft.res_name, count = size }
            if toCraft.type == "item" then
                bridge.craftItem(filter)
            elseif toCraft.type == "fluid" then
                bridge.craftFluid(filter)
            print("Crafting some delicious " .. toCraft.name .. " " .. filter.count .. " times")
        end
    end

end

function checkTable()
    for i = 1, #resources do
        checkMe(resources[i])
    end
end






while true do
    checkTable()
    sleep(1)
end