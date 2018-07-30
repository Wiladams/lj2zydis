local ffi = require("ffi")

require("lj2zydis.ffi.CommonTypes")
require("lj2zydis.ffi.Decoder")
require("lj2zydis.ffi.DecoderTypes")
require("lj2zydis.ffi.Formatter")
require("lj2zydis.ffi.MetaInfo")
require("lj2zydis.ffi.Mnemonic")
require("lj2zydis.ffi.Register")
require("lj2zydis.ffi.SharedTypes")
require("lj2zydis.ffi.Status")
require("lj2zydis.ffi.String")
require("lj2zydis.ffi.Utils")


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