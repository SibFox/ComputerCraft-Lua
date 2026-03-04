-- Code by SibFox

local githuburl = ""--"https://raw.githubusercontent.com/SirEndii/Lua-Projects/refs/heads/master/src/Programs.txt"

local programs = {}

local args = { ... }

function exit(message, isError)
    term.setTextColor(isError and colors.red or colors.yellow)
    print(">"..message)
    term.setTextColor(colors.white)
    if isError then
        error()
    end
end

function loadSources()
    local dl, error = http.get(githuburl)
    if dl then
        text = dl.readAll()
        text:gsub("\n", "")
        text:gsub("\\", "")
        programs = textutils.unserialize(text)
    end
end

function install(program)
    if program == nil then
        exit("> Specify a program", true)
    end

    if programs[program] == nil then
        exit("Program '" .. program .. "' does not exists", true)
    end

    local startup = programs[program]["startup"]

    if fs.exists(program) then
        exit("Program is already installed. Either use the 'delete' or 'update' command", true)
    end

    local rmStartup = false
    if fs.exists("startup") then
        print("Delete startup file?")
        if io.write == "y" or "Y" then
            rmStartup = true
            fs.delete("startup")
        else
            exit("Dropping program installation", true)
        end
    end

    if rmStartup then
        local sfile = fs.open("startup", "w")
        sfile.write(startup)
        sfile.close()        
    end
    
    libraries = {}
    
    programName = ""
    programPath = ""
    for _, v in ipairs(programs[program]["files"]) do
        if v.type == "program" then
           programPath = v.link 
           programName = v.name
        elseif v.type == "api" then
            table.insert(libraries, v)
        end
    end
    
    for _, v in ipairs(libraries) do
        term.setTextColor(colors.yellow)
        print("Downloading library ".. v.name .."...")
        shell.run("wget ".. v.link .." ".. program .."/api/".. v.name)
    end
    
    term.setTextColor(colors.yellow)
    print("Downloading program ".. program .."...")
    shell.run("wget ".. programPath .." ".. program .."/".. programName)
    term.setTextColor(colors.lime)
    print("Successfully installed ".. program)
end

function update(program)
    delete(program)

    print("Now installing the latest version from github...")
    install(program)
end

function delete(program)
    if program == nil then
        exit("Specify a program", true)
    end

    term.setTextColor(colors.yellow)
    print("WARNING: This option is quite primitive. It will uninstall all libraries used by this script even if they are used by others")

    print("Deleting program and libraries for '" .. program .. "'...")

    if programs[program] == nil then
        exit("Program '" .. program .. "' does not exists", true)
    end

    if fs.exists("startup") then
        print("Delete startup file?")
        if io.write == "y" or "Y" then
            rmStartup = true
            fs.delete("startup")
        else
            exit("Dropping program deletion", true)
        end
    end

    libraries = {}
    
    programName = ""
    programPath = ""
    for k, v in ipairs(programs[program]["files"]) do
        if v.type == "program" then
           programPath = v.link 
           programName = v.name
        elseif v.type == "api" then
            print(v)
            table.insert(libraries, v)
        end
    end

    for k, v in ipairs(libraries) do
        term.setTextColor(colors.yellow)
        print("Deleting library ".. v.name .."...")
        shell.run("rm ".. program .."/api/".. v.name)
        term.setTextColor(colors.lime)
        print("Deleted library ".. v.name)
    end

    term.setTextColor(colors.yellow)
    print("Deleting program ".. program .."...")
    shell.run("rm ".. program .."/".. programName)
    shell.run("rm ".. program .."/")
    term.setTextColor(colors.lime)
    print("Successfully uninstalled ".. program)
end