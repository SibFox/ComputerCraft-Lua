local function info()
    print("Provided by Nezer Inc.")
    print("Made by SibFox")
    print("Version 0.1")
end

---Clears terminal and places cursor to provided position
---@param posX? number
---@param posY? number
local function clearTerm(posX, posY)
    posX = posX or 1
    posY = posY or 1
    term.clear()
    term.setCursorPos(posX, posY)
end

---@param text string
local function writeCenter(text)
  local x, y = term.getCursorPos()
  local width, height = term.getSize()
  term.setCursorPos(math.floor((width - #text) / 2) + 1, y)
  term.write(text)
end

---@param message? string
---@param isError? boolean
local function exit(message, isError)
    term.setTextColor(isError and colors.red or colors.yellow)
    print("> "..message)
    term.setTextColor(colors.white)
    if isError then
        error()
    end
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
        write(rep("\t", level), "{\n")
        level = level + 1

        for key, value in pairs(t) do
            write(rep("\t", level) .. format("[%s] = ", key))
            printTable(value, level)
            write(",\n")
        end

        level = level - 1
        write(rep("\t", level), "}")
    else
        write(tostring(t))
    end
    -- print new line on the level 0
    if level == 0 then
        write("\n")
    end
end

---@param n number
---@param ... any
function switch(n, ...)
  for _,v in ipairs {...} do
    if v[1] == n or v[1] == nil then
      return v[2]()
    end
  end
end

---@param n number
---@param f function
function case(n,f)
  return {n,f}
end

---@param f function
function default(f)
  return {nil,f}
end

return {
    info = info, clearTerm = clearTerm, writeCenter = writeCenter,
    printTable = printTable, exit = exit, contains = contains,
    switch = switch, case = case, default = default
}
