os.execute("clear")
if not DTDUser then DTDUser = { name = "Dougla037" } end
do
    local ss = io.popen("curl -s https://raw.githubusercontent.com/nathanc0dxxx-cpu/DTD/main/SystemManagers/DTDIssueService.lua")
    if ss then load(ss:read("*a"))() ss:close() else print("\27[91merror while loading issue service...\27[0") return end
end
local inboxid = nil
local messages = {}
local function loadinbox()
    messages = {}
    print("\27[93mloading inbox...\27[0m")
    local issues = DTDIssueService.get()
    local found = false
    inboxid = nil
    for i,v in ipairs(issues) do
        if v.content == "inbox" then
            inboxid = v.id
            found = true
        end
    end
    if found == false then
        print("\27[93minbox not found... generating new...\27[0m")
        DTDIssueService.new("inbox")
        print("\27[92mgenerated! please reload")
        os.execute("sleep 4")
    else
        print("\27[93mloading mails...\27[0m")
        messages = DTDIssueService.comment.read(inboxid)
    end local m = messages
    messages = {}
    for i,v in ipairs(m) do
        local a,b,c = v.body:match("^%s*(.-)%s*@%s*(.-)%s*@%s*(.*)%s*$")
        c = c:gsub("<$circle$>dtd","@")
        local obj = { owner = a, to = b, content = c, id = v.id }
        table.insert(messages, obj)
    end
end loadinbox()

local inboxsession = true

while inboxsession do
    os.execute("clear")
    print("\27[0m\27[44m[Your Mails]:\27[0m\n")
    do
        local found = false
        local max = 2
        for i,v in ipairs(messages) do
            if v.to == DTDUser.name or v.to == "all" then
                io.write("\n  \27[94m@"..v.owner.."\27[0m:\n   "..v.content.."\n--------------")
                found = true
            end
            if i >= max then
                print("\n")
                max = max + 2
            end
        end
        if found == false then
            io.write("\27[90m  hmm... no mail today!...\27[0m")
        end
    end
    print("\n\n\27[0m\27[44m[==========]:\27[0m")
    io.write("-> \27[90mexit, reset, write, markall, view\27[33D\27[92m")
    local inp = io.read()
    io.write("\27[0m")
    if inp == "exit" then
        os.execute("clear")
        print("\27[91mlogout\27[0m")
        inboxsession = false
    elseif inp == "reset" then
        loadinbox()
    elseif inp == "write" then
        local users = {}
        do
            local ss = io.popen("curl -s https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/Accounts")
            local header = ""
            if ss then header = ss:read("*a") ss:close() else print("\27[91mfailed while loading users...\27[0m") return end
            for v in header:gmatch("\"name\"%s*:%s*\"(.-)\"") do
                table.insert(users, v)
            end
        end
        local session = true
        local nextt = false
        local to = ""
        while session do
            os.execute("clear")
            print("\27[44m[From]:\27[0m "..DTDUser.name.."\n\27[44m[To]:\27[0m "..to.."\n\27[44m[Content]:\27[0m")
            if nextt == false then
                io.write("\27[2A\27[6C")
                to = io.read()
            end
            if to ~= "all" and nextt == false then
                for i,v in ipairs(users) do
                    if v == to then
                        nextt = true
                        to = v
                        break
                    end
                end if nextt == false then to = "" end
            elseif to == "all" and nextt == false then
                nextt = true
                to = "all"
            else
                io.write("\27[3B\27[91mno user provided!\27[0m")
            end
            if nextt == true then
                session = false
                io.write("\27[1B")
                local content = ""
                io.write(" > ")
                local content = io.read()
                content = content:gsub("@", "<$circle$>")
                if #content:gsub(" ","") >= 5 then
                    os.execute("clear")
                    print("\27[92msending...\27[0m")
                    DTDIssueService.comment.add(inboxid, DTDUser.name.."@"..to.."@"..content)
                    print("\27[92msucess!\27[0m")
                else
                    print("\27[1A\27[91mcontent need to have more than 5 valid chars\27[0m")
                    io.read()
                end
            end
        end
    elseif inp == "markall" then
        local found = false
        for i,v in ipairs(messages) do
            if v.to == DTDUser.name then
                print("\27[93mremoving mail "..i.."\27[0m")
                DTDIssueService.comment.remove(v.id)
                found = true
            end
        end
        if found == true then
            print("\27[92mall mails removed!\27[0m")
            loadinbox()
        else
            print("\27[91mim dont found any specific emails for you to mark...\27[0m")
        end
        io.read()
    elseif inp:sub(1,6) == "view" then
        local session = true
        while session do
            os.execute("clear")
            local mails = {}
            for i,v in ipairs(messages) do
                if v.owner == DTDUser.name then
                    table.insert(mails, v)
                end
            end
            print("\27[0m\27[44m[DMails you writted!]:\27[0m")
            if mails[1] then
                for i,v in ipairs(mails) do
                    io.write("\n\27[94m "..i.." \27[92m["..v.to.."]\27[0m:\27[90m "..v.content:sub(1,10).."...\27[0m")
                end
            else
                io.write("\n\27[90m  no dmails for now...\27[0m")
            end
            print("\n\n\27[0m\27[44m[===================]:\27[0m")
            io.write(" > \27[90mback, delete\27[12D\27[92m")
            local uinp = io.read()
            if uinp == "back" then
                os.execute("clear")
                session = false
            elseif uinp:sub(1,6) == "delete" then
                local query = uinp:sub(8)
                local found = false
                for i,v in ipairs(mails) do
                    if i == tonumber(query) then
                        found = true
                        print("\27[93mremoving dmail "..i.." from user "..v.to)
                        DTDIssueService.comment.remove(v.id)
                        break
                    end
                end
                if found == true then
                    print("\27[92mdmail removed!\27[0m")
                    os.execute("sleep 1")
                    loadinbox()
                else
                    print("\27[91mno dmail with id "..query.." found...\27[0m")
                    io.read()
                end
            end
        end
    end
end