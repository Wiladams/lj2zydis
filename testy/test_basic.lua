package.path = "../?.lua;"..package.path

local zydis = require("lj2zydis.zydis_ffi")

print(zydis.ZydisGetVersion())