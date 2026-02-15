
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
for i,v in ipairs(DTDIssueService) do
    v = function() end
end