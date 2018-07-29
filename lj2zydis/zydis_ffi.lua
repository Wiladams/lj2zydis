local ffi = require("ffi")

require("lj2zydis.CommonTypes")
require("lj2zydis.Decoder")
require("lj2zydis.DecoderTypes")
require("lj2zydis.Formatter")
require("lj2zydis.MetaInfo")
require("lj2zydis.Mnemonic")
require("lj2zydis.Register")
require("lj2zydis.SharedTypes")
require("lj2zydis.Status")
require("lj2zydis.String")
require("lj2zydis.Utils")


ffi.cdef[[
typedef ZydisU8 ZydisFeature;

enum ZydisFeatures
{
    ZYDIS_FEATURE_EVEX,
    ZYDIS_FEATURE_MVEX,
};
]]



ffi.cdef[[
ZydisBool ZydisIsFeatureEnabled(ZydisFeature feature);
ZydisU64 ZydisGetVersion(void);
]]


local ZydisLib = ffi.load("zydis");

-- set metamethod on ZydisDecoder to ease construction
local ZydisDecoder_mt = {
    __new = function(ct,  machineMode, addressWidth)
        machineMode = machineMode or ffi.C.ZYDIS_MACHINE_MODE_LONG_64;
        addressWidth = addressWidth or ffi.C.ZYDIS_ADDRESS_WIDTH_64;

		local obj = ffi.new(ct)
        ZydisLib.ZydisDecoderInit(obj, machineMode, addressWidth)

		return obj;
    end;
    
    __index = {
        DecodeBuffer = function(self, buffer, bufferLen, instructionPointer, instruction)
            return ZydisLib.ZydisDecoderDecodeBuffer(self, buffer, bufferLen, instructionPointer, instruction) == 0;
        end
    };
}
ffi.metatype(ffi.typeof("ZydisDecoder"), ZydisDecoder_mt);

-- set metamethod on ZydisFormatter to ease construction
local ZydisFormatter_mt = {
    __new = function(ct, style)
        style = style or ffi.C.ZYDIS_FORMATTER_STYLE_INTEL;
		local obj = ffi.new(ct)
        ZydisLib.ZydisFormatterInit(obj, style)

		return obj;
    end,
    
    __index = {
        FormatInstruction = function(self, instruction, buffer, bufferLen)
            return ZydisLib.ZydisFormatterFormatInstruction(self, instruction, buffer, bufferLen) == 0;
        end
    };
}
ffi.metatype(ffi.typeof("ZydisFormatter"), ZydisFormatter_mt);


local exports = {
    Lib = ZydisLib;

    ZYDIS_VERSION = 0x0002000000020000ULL;

    ZydisGetVersion = ZydisLib.ZydisGetVersion;

    -- Decoder
    ZydisDecoder = ffi.typeof("ZydisDecoder");
    ZydisDecoderInit = ZydisLib.ZydisDecoderInit;
    ZydisDecoderEnableMode = ZydisLib.ZydisDecoderEnableMode;
    ZydisDecoderDecodeBuffer = ZydisLib.ZydisDecoderDecodeBuffer;

    -- Formatter
    ZydisFormatter = ffi.typeof("ZydisFormatter");
    ZydisFormatterInit = ZydisLib.ZydisFormatterInit;
    ZydisFormatterSetProperty = ZydisLib.ZydisFormatterSetProperty;
    ZydisFormatterSetHook = ZydisLib.ZydisFormatterSetHook;
    ZydisFormatterFormatInstruction = ZydisLib.ZydisFormatterFormatInstruction;
    ZydisFormatterFormatInstructionEx = ZydisLib.ZydisFormatterFormatInstructionEx;
    ZydisFormatterFormatOperand = ZydisLib.ZydisFormatterFormatOperand;
    ZydisFormatterFormatOperandEx = ZydisLib.ZydisFormatterFormatOperandEx;
}

return exports