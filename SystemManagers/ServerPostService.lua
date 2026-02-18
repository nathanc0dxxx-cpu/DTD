--please dont destroy my project!

function base64(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s = ""
    local padding = 0

    for i = 1, #data, 3 do
        local bytes = {string.byte(data, i, i+2)}
        if #bytes < 3 then
            padding = 3 - #bytes
            for j = #bytes+1, 3 do
                bytes[j] = 0
            end
        end

        local n = bytes[1] * 2^16 + bytes[2] * 2^8 + bytes[3]

        s = s .. string.sub(b, math.floor(n / 2^18) % 64 + 1, math.floor(n / 2^18) % 64 + 1)
        s = s .. string.sub(b, math.floor(n / 2^12) % 64 + 1, math.floor(n / 2^12) % 64 + 1)
        s = s .. string.sub(b, math.floor(n / 2^6) % 64 + 1, math.floor(n / 2^6) % 64 + 1)
        s = s .. string.sub(b, n % 64 + 1, n % 64 + 1)
    end

    if padding > 0 then
        s = s:sub(1, #s - padding) .. string.rep("=", padding)
    end

    return s
end

local function getSHA(url, token)
    local handle = io.popen(string.format('curl -s -H "Authorization: token %s" %s', token, url))
    local result = handle:read("*a")
    handle:close()
    local sha = result:match('"sha"%s*:%s*"([%w]+)"')
if sha == nil then
  print(result)
else
    return sha
end
end

local function post(url, content, mode)
local dtkg = os.getenv("PAT")
  local sha = ""
  if mode == "PUT" or mode == "DELETE" then
    sha = getSHA(url, dtkg)
  end
local commit = "update"
if _G.DTDUser then commit = _G.DTDUser.name .. "as sent a post request" end
if content == nil then content = "PLACEHOLDER" end

local jsun = '{"message":"%s","content":"%s","sha":"%s"}'
print(jsun)
if mode == "POST" then
    jsun = jsun:gsub(",\"sha\":\"%s\"","")
    jsun = jsun:format(commit, content,sha)
elseif mode == "DELETE" then
    jsun = jsun:gsub(",\"content\":\"%s\"","")
    jsun = jsun:format(commit,content, sha)
elseif mode == "PUT" then
    jsun = jsun:format(commit, content, sha)
end

if mode then
os.execute(string.format('curl -s -X %s -H "Authorization: token %s" -H "Content-Type: application/json" -d \'%s\' %s',mode:gsub("POST","PUT"),dtkg,jsun,url))
end
end

_G.ServerPostService = {
  post = function(cont, file, mode)
    post("https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/contents/"..file, cont, mode)
  end,
}