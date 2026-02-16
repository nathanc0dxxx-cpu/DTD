local token = "ghp_VFb1kXtYJ68rDzuhn41f2xbcegago30naUb".."f"

local function post(issue, cont, mode)
    local fil = io.open("DTDUser","r")
    local c = ""
    if fil then
        local cc = fil:read("*a")
        fil:close()
        local args = {}
        for v in cc:gmatch("%S+") do
            table.insert(args, v)
        end
        c = args[2]
    else
        return
    end
    os.execute(string.format([[
      curl -s -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: token %s" \
      https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/dispatches \
      -d '{
        "event_type": "comment",
        "client_payload": {
          "user": "%s",
          "pass": "%s",
          "mode": "%s",
          "issue": "%s",
          "content": "%s"
        }
      }'
   ]], token, DTDUser.name, c, mode, issue, cont))
end

_G.DTDIssueService = {
    get = function()
        local tab = {}
        local n = 1
        while true do
            local s = io.popen("curl -si -H 'Authorization: token "..token.."' https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues?per_page=100&state=open&page="..n)
            if s then
                local c = s:read("*a")
                s:close()

                for i,v in c:gmatch("\"title\"%s*:%s*\"(.-)\",.-%s*\"number\"%s*:%s*(%d+)") do
                    local obj = { content = i, id = v }
                    table.insert(tab, obj)
                end
                if c:match('rel="next"') then
                    n = n + 1
                else
                    break
                end
            else
                tab = false
                break
            end
        end
        return tab
    end,
    finish = function()
        DTDIssueService = nil
    end,
    comment = {
        add = function(issue, content)
            post(issue, content, "add")
        end,
        remove = function(issue)
            post(issue, "", "remove")
        end,
        read = function(target)
            local tab = {}
            local n = 1
            local ids = nil
            local isss = DTDIssueService.get()
            if isss == false then return end
            for i,v in ipairs(isss) do
                if v.content == target then
                    ids = v.id
                    break
                end
            end
            if ids == nil then return end
            while true do
                local s = io.popen("curl -si -H 'Authorization: token "..token.."' https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues/"..ids.."/comments?per_page=100&page="..n)
                if s then
                    local c = s:read("*a")
                    s:close()

                    for i,v in c:gmatch("\"id\"%s*:%s*(%d+),.-%s*\"body\"%s*:%s*\"(.-)\"") do
                        local obj = { id = i, body = v }
                        table.insert(tab, obj)
                    end
                    if c:match('rel="next"') then
                        n = n + 1
                    else
                        break
                    end
                else
                    tab = false
                    break
                end
            end
            return tab
        end,
    },
}