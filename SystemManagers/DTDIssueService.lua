
local dtdks = "github_pat_11B4ZK35Q03lx8PW9foLDz_GKsDc3LZsfJZwfpItyBlce6wcoo".."H4IaFqsMs43WUY52GFVHMQFXRczdslza"
local function newissue(title)
    if title then
        os.execute(string.format('curl -X POST -H "Authorization: token %s" -H "Accept: application/vnd.github+json" https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues -d \'{"title": "%s"}\'',
        dtdks, title))
    end
end

local cmd2 = 'curl -s -H "Authorization: token %s" -H "Accept: application/vnd.github+json" https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues?state=all&per_page=100'
local cmd3 = 'curl -X PATCH -H "Authorization: token %s" -H "Accept: application/vnd.github+json" https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/issues/%s -d \'{"state": "closed"}\''

local function getissues()
    local ss = io.popen(string.format(cmd2, dtdks))
    local content = ""
    if ss then content = ss:read("*a") ss:close() else return nil end
    local tab = {}
    for i,g,v in content:gmatch("%s*\"number\"%s*:%s*(%d+),.-%s*\"state\"%s*:%s*\"(.-)\",.-%s*\"title\"%s*:%s*\"(.-)\"") do
        local obj = { id = i, state = g, content = v }
        table.insert(tab, obj)
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

_G.DTDIssueService = {
    new = newissue,
    close = closeissue,
    get = getissues,
    finish = function()
        DTDIssueService = nil
    end,
}