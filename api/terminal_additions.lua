local function info()
    print("i> Provided by Nezer Inc.")
    print("i> Made by SibFox")
    print("i> Terminal additions module")
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
  term.write(text.."\n")
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

return {
    info = info, clearTerm = clearTerm, writeCenter = writeCenter, exit = exit
}
