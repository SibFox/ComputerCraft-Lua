local function info()
    print("i> Provided by Nezer Inc.")
    print("i> Made by SibFox")
    print("i> Table additions module")
end

---@param tab table
---@param val any
local function contains(tab, val)
    for i, v in ipairs(tab) do
        if v == val then
            return true, i
        end
    end

    return false
end

---Recursively print the table, if not table value is just printed.
---@param t any
---@param level? number
local function printTable(t, level)
    level = level or 0
    if type(t) == "table" then
        -- do not print new line on the level 0
        if level ~= 0 then
            write("\n")
        end
        write(string.rep("\t", level), "{\n")
        level = level + 1

        for key, value in pairs(t) do
            write(string.rep("\t", level) .. string.format("[%s] = ", key))
            printTable(value, level)
            write(",\n")
        end

        level = level - 1
        write(string.rep("\t", level), "}")
    else
        write(tostring(t))
    end
    -- print new line on the level 0
    if level == 0 then
        write("\n")
    end
end

return {
    info = info, printTable = printTable, contains = contains
}
