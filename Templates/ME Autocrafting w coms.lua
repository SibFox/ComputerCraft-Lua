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

    resource = bridge.getItem({ name = toCraft.res_name, type = toCraft.type })

    -- if toCraft.type == "item" then
    --     resource = bridge.getItem({name = toCraft.res_name, type = toCraft.type})
    -- elseif toCraft.type == "fluid" then
    --     resource = bridge.getFluid({name = toCraft.res_name, type = toCraft.type})
    -- elseif toCraft.type == "chemical" then
    --     resource = bridge.getChemical({name = toCraft.res_name, type = toCraft.type})
    -- end

    if not resource then
        size = 0
    else
        size = resource.count
    end
    -- row = row + 1
    -- local currentlyCrafting = 0
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

    -- if isCrafting then
    --     for k, v in ipairs(bridge.getCraftingTasks()) do
    --         local crafting = v.resource
    --         if crafting.name == toCraft.res_name then
    --             -- This means that the crafted amount couldn't be calculated
    --             if (v.crafted == -1) then
    --                 currentlyCrafting = currentlyCrafting + v.quantity
    --             else 
    --                 currentlyCrafting = currentlyCrafting + (v.quantity - v.crafted)
    --             end
    --         end
    --     end
    -- end

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