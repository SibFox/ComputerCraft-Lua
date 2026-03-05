local function info()
    print("i> Provided by Nezer Inc.")
    print("i> Made by SibFox")
    print("i> Switch module")
end

---@param n any
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
    info = info, switch = switch, case = case, default = default
}
