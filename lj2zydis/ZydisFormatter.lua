local ffi = require("ffi")

require("lj2zydis.ffi.Formatter")
local zydis = require("lj2zydis.zydis")

local ZydisLib = zydis.Lib;

-- A basic class to wrap ZydisFormatter functions
local ZydisFormatter = {}

-- set metamethod on ZydisFormatter to ease construction
-- Since we're still using the ZydisFormatter 'C' struct
-- we have to associate a metatype with it
local ZydisFormatter_mt = {
    __new = function(ct, style)
        style = style or ffi.C.ZYDIS_FORMATTER_STYLE_INTEL;
		local obj = ffi.new(ct)
        ZydisLib.ZydisFormatterInit(obj, style)

		return obj;
    end,
--[[    
    __index = {
        FormatInstruction = function(self, instruction, buffer, bufferLen)
            return ZydisLib.ZydisFormatterFormatInstruction(self, instruction, buffer, bufferLen) == 0;
        end
    };
--]]
    __index = ZydisFormatter;
}
ffi.metatype(ffi.typeof("ZydisFormatter"), ZydisFormatter_mt);

--[[
    Actual functions
]]
function ZydisFormatter.FormatInstruction(self, instruction, buffer, bufferLen)
    return ZydisLib.ZydisFormatterFormatInstruction(self, instruction, buffer, bufferLen) == 0;
end

return ffi.typeof("ZydisFormatter")
