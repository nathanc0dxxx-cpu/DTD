
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

local function post(url, cont, mode)
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
    print("\27[93madapting json...\27[0m")
    local cc = base64(cont)

    local token = "ghp_VFb1kXtYJ68rDzuhn41f2xbcegago30naUb".."f"
    os.execute(string.format('curl -s -X POST -H "Accept: application/vnd.github+json" -H "Authorization: token %s" https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/dispatches -d \'{"event_type": "post", "client_payload": {"user": "%s", "pass": "%s", "mode": "%s", "file": "%s", "content": "%s"}}\'', token, DTDUser.name, c, mode, url, cc))
end

_G.DTDPostService = {
  market = function(self, cont, file, mode)
    post("Market/"..file, cont, mode)
  end,
  servers = function(self, cont, file, mode)
    post("Servers/"..file, cont, mode)
  end,
  accounts = function(self, cont, file, mode)
    post("Accounts/"..file, cont, mode)
  end,
  cloud = function(self, cont, file, mode)
    post("Cloud/"..file, cont, mode)
  end,
  post = function(cont, file, mode)
    post(file, cont, mode)
  end,
}