local function info()
    print("i> Provided by Nezer Inc.")
    print("i> Made by SibFox")
    print("i> Formatable string module")
end

---@param ... table
function build(...)
  for _, v in ipairs(...) do
    if isStrFormatable(v) then
      term.setTextColor(v.color)
      write(v.text)
      if newLine then
        write('\n')
      end
    end
  end
  term.setTextColor(color.white)
end

---@param ... table
function create(...)
  local collection
  for _, v in ipairs(...) do
    if isStrFormatable(v) then
      table.insert(collection, v)
    end
  end
  return collection
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

---@param tStr table
function isStrFormatable(tStr)
  return tStr.formatable
end

return {
  info = info, create = create, build = build, defString = defString, setColor = setColor, isStrFormatable = isStrFormatable
}
