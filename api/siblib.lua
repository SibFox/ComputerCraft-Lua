local function info()
    print("i> Provided by Native Zeal Co.")
    print("i> Made by SibFox")
    print("i> Overall module")
end

---@param inputstr string|number
---@param sep? string|number
function splitstr(inputstr, sep)
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

---@param n number
---@param low number
---@param high number
function clamp(n, low, high) return math.min(math.max(n, low), high) end

return {
  info = info, splitstr = splitstr, clamp = clamp
}
