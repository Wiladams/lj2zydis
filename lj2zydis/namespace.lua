local function namespace(res)
    res = res or {}
    setmetatable(res, {__index= _G})
    setfenv(2, res)
    return res
end

return namespace
