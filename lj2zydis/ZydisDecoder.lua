local ffi = require("ffi")
require("lj2zydis.ffi.Decoder")
local zydis = require("lj2zydis.zydis")

local ZydisLib = zydis.Lib;


local ZydisDecoder = {}
-- set metamethod on ZydisDecoder to ease construction
local ZydisDecoder_mt = {
    __new = function(ct,  machineMode, addressWidth)
        machineMode = machineMode or ffi.C.ZYDIS_MACHINE_MODE_LONG_64;
        addressWidth = addressWidth or ffi.C.ZYDIS_ADDRESS_WIDTH_64;

		local obj = ffi.new(ct)
        ZydisLib.ZydisDecoderInit(obj, machineMode, addressWidth)

		return obj;
    end;
    
    __index = ZydisDecoder;

}
ffi.metatype(ffi.typeof("ZydisDecoder"), ZydisDecoder_mt);


function ZydisDecoder.DecodeBuffer(self, buffer, bufferLen, instructionPointer, instruction)
    return ZydisLib.ZydisDecoderDecodeBuffer(self, buffer, bufferLen, instructionPointer, instruction) == 0;
end

function ZydisDecoder.EnableMode(self, mode, enabled)
    mode = mode or ffi.C.ZYDIS_DECODER_MODE_MINIMAL;
    local able = 1;
    if not enabled then able = 0 end

    return ZydisLib.ZydisDecoderEnableMode(self, mode, able) == 0;
end

return ffi.typeof("ZydisDecoder")
