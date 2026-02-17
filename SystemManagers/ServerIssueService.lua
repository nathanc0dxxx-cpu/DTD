
local dtdks = os.getenv("PAT")
local function newissue(title)
    if title then
        os.execute(string.format('curl -X POST -H "Authorization: token %s" -H "Accept: application/vnd.github+json" https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues -d \'{"title": "%s"}\'',
        dtdks, title))
    end
end

local cmd2 = 'curl -si -H "Authorization: token %s" -H "Accept: application/vnd.github+json" "https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues?state=open&per_page=100&page=%s"'
local cmd3 = 'curl -s -X PATCH -H "Authorization: token %s" -H "Accept: application/vnd.github+json" "https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues/%s" -d \'{"state": "closed"}\''

local function getissues()
    local roling = true
    local tab = {}
    local page = 1
    while roling do
        local ss = io.popen(string.format(cmd2, dtdks, tostring(page)))
        local content = ""
        if ss then content = ss:read("*a") ss:close() else return nil end
        for i,v in content:gmatch("\"number\"%s*:%s*(%d-),.-%s*\"title\"%s*:%s*\"(.-)\"") do
            local obj = { id = i, content = v }
            table.insert(tab, obj)
        end if not content:match("rel=\"next\"") then
            roling = false
        else
            page = page + 1
        end
    end
    return tab, content
end

local function closeissue(issue)
    local y = getissues()
    for i,v in ipairs(y) do
        if v.content == issue then
            print(v.content)
            os.execute(string.format(cmd3, dtdks, v.id))
            break
        end
    end
end

local cmdcd = 'curl -s -X DELETE "https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues/comments/%s" -H "Authorization: token %s" -H "Accept: application/vnd.github+json"'
local cmdca = 'curl -s -X POST "https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues/%s/comments" -H "Authorization: token %s" -H "Accept: application/vnd.github+json" -H "Content-Type: application/json" -d \'{"body": "%s"}\''
local cmdcg = 'curl -si -X GET "https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues/%s/comments?page=%s&per_page=100" -H "Authorization: token %s" -H "Accept: application/vnd.github+json"'

local function comment(issue, body)
    local toexec = string.format(cmdca, issue, dtdks, body)
    os.execute(toexec)
end
local function deletec(id)
    os.execute(string.format(cmdcd, id, dtdks))
end
local function getcomments(number)
    local page = 1
    local objs = {}
    local roling = true
    while roling do
        local handle = io.popen(string.format(cmdcg, number, tostring(page), dtdks))
        local header = handle:read("*a")
        handle:close()
        for i,v in header:gmatch("\"id\"%s*:%s*(.-),.-%s*\"body\"%s*:%s*\"(.-)\"") do
            local obj = { id = i, body = v }
            table.insert(objs, obj)
        end if not header:match("rel=\"next\"") then
            roling = false
        else
            page = page + 1
        end
    end
    return objs
end

_G.ServerIssueService = {
    new = newissue,
    close = closeissue,
    get = getissues,
    finish = function()
        DTDIssueService = nil
    end,
    comment = {
        add = comment,
        remove = deletec,
        read = getcomments,
    },
}