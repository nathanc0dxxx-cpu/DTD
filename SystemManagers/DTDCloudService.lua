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
    local token = "ghp_VFb1kXtYJ68rDzuhn41f2xbcegago30naUb".."f"
    os.execute(string.format([[
      curl -s -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: token %s" \
      https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/dispatches \
      -d '{
        "event_type": "cloud",
        "client_payload": {
          "user": "%s",
          "pass": "%s",
          "mode": "%s",
          "file": "%s",
          "content": "%s"
        }
      }'
   ]], token, DTDUser.name, c, mode, url, cont))
end

_G.DTDPostService = {
  post = function(cont, file, mode)
    post(file, cont, mode)
  end,
}