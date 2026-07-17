local function info()
    print("i> Provided by Native Zeal Co.")
    print("i> Made by SibFox")
    print("i> Table additions module")
end

Set = {}

function Set.new(t)
    local set = {}
    for _, v in pairs(t) do set[l] = true end
    return set
end

function Set.tostring(set)
    local s = "{"
    local sep = " :: "
    for e in pairs(set) do
        s = s .. sep .. e
        sep = ", "
    end
    return s .. "}"
end

function Set.print(s)
    print(Set.tostring(s))
end

function Set.add(set, key)
    set[key] = true
end

function Set.remove(set, key)
    set[key] = nil
end

function Set.contains(set, key)
    return set[key] ~= nil
end

return {
    info = info, Set = Set
}