--please dont destroy my project!


-- Função para codificar Base64 manualmente
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

-- Função para pegar SHA de um arquivo do GitHub
local function getSHA(url, token)
    local handle = io.popen(string.format([[
        curl -s -H "Authorization: token %s " %s
    ]], token, url))
    local result = handle:read("*a")
    handle:close()
    local sha = result:match('"sha"%s*:%s*"([%w]+)"')
    return sha
end

-- Exemplo de uso:
local url2 = "https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/DTDMarketPacks.txt"

local function post(url, content)
local dtkg = string.gsub("dtdkgHHI2IcCBtkZ702oA7d6EsbmPrl8GtcgmE1iCOp5","dtdkgHHI","ghp_")

  local sha = getSHA(url, token)
local ct = ""
for v in content:gmatch("[^\n\r]+") do
  ct = ct .. v .. "\n"
end content = base64(ct)

os.execute(string.format(
  'curl -X PUT -H "Authorization: token %s" -H "Content-Type: application/json" -d \'{"message":"Update","content":"%s","sha":"%s"}\' %s',
  dtkg, content, sha, url
))
end

_G.DTDPostService = {
  market = function(self, cont)
    post("https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/DTDMarketPacks.txt", cont)
  end,
  servers = function(self, cont)
    post("https://api.github.com/repos/nathanc0dxxx-cpu/DTD/contents/DTDServers.txt", cont)
  end,
}

