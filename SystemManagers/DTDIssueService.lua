
_G.DTDIssueService = {
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

for k, v in pairs(DTDIssueService) do
    if type(v) == "function" then
        DTDIssueService[k] = function() end
    elseif type(v) == "table" then
        for k2, v2 in pairs(v) do
            if type(v2) == "function" then
                v[k2] = function() end
            end
        end
    end
end