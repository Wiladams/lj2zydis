package.path = "../?.lua;"..package.path

local ffi = require("ffi")
local bit = require("bit")

local zydis = require("lj2zydis.zydis")

print("Version: ",bit.tohex(zydis.ZydisGetVersion()))