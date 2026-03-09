local function info()
    print("i> Provided by Nezer Inc.")
    print("i> Made by SibFox")
    print("i> Formatable string module")
end

---@param collection table
function build(collection)
  for _, v in ipairs(collection) do
    if isStrFormatable(v) then
      term.setTextColor(v.color)
      write(v.text)
      if newLine then
        write('\n')
      end
    end
  end
  term.setTextColor(colors.white)
end

---@param ... table
function create(...)
  local tCollection = {}
  for _, v in ipairs(...) do
    if isStrFormatable(v) then
      table.insert(tCollection, v)
    end
  end
  tCollection.formatable = true
  return tCollection
end

---@param str string
---@param newLine? boolean
function defString(str, newLine)
  newLine = newLine or true
  return { text = str, newLine = newLine, color = colors.white, formatable = true }
end

---@param fstr table
---@param c number Should be a 'colors' constant
function setColor(fstr, c)
  if not isStrFormatable(fstr) then
    error("> String is not formatable")
    return false
  end
  fstr.color = c
  return fstr
end

---@param fCollection table
---@param str string
local function find(fCollection, str)
  if fCollection ~= nil then
    for i, v in pairs(fCollection) do
      if v ~= nil then
        if v.text == str then
          return true, i
        end
      end
    end
  end
  return false
end

---@param tStr table
function isStrFormatable(tStr)
  if tStr ~= nil then
    return tStr.formatable
  end
  return false
end

return {
  info = info, create = create, build = build, defString = defString, setColor = setColor, isStrFormatable = isStrFormatable, find = find
}
