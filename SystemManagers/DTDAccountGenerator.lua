function simple_hash(password, salt)
    local hash = 0
    local data = password .. salt

    for i = 1, #data do
        local c = data:byte(i)
        hash = (hash * 31 + c) % 4294967296
    end

    return string.format("%08x", hash)
end

function generate_salt(length)
    local charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local salt = ""
    for i = 1, length do
        local rand = math.random(1, #charset)
        salt = salt .. charset:sub(rand, rand)
    end
    return salt
end

function genuser(name, pass)
    if not name then return end
    if not pass then return end
    os.execute(string.format([[
        curl -s -X POST \
      -H "Accept: application/vnd.github+json" \
      -H "Authorization: token %s" \
      https://api.github.com/repos/tutugrande1235-DTD/DTD-Source-Scripts/dispatches \
      -d '{
        "event_type": "newuser",
        "client_payload": {
          "user": "%s",
          "pass": "%s",
        }
      }'
    ]], name, pass))
end