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

local exports = {
    Lib = ZydisLib;

    ZYDIS_VERSION = 0x0002000000020000ULL;

    ZydisGetVersion = ZydisLib.ZydisGetVersion;

    -- Decoder
    ZydisDecoderInit = ZydisLib.ZydisDecoderInit;
    ZydisDecoderEnableMode = ZydisLib.ZydisDecoderEnableMode;
    ZydisDecoderDecodeBuffer = ZydisLib.ZydisDecoderDecodeBuffer;

    -- Formatter
    ZydisFormatterInit = ZydisLib.ZydisFormatterInit;
    ZydisFormatterSetProperty = ZydisLib.ZydisFormatterSetProperty;
    ZydisFormatterSetHook = ZydisLib.ZydisFormatterSetHook;
    ZydisFormatterFormatInstruction = ZydisLib.ZydisFormatterFormatInstruction;
    ZydisFormatterFormatInstructionEx = ZydisLib.ZydisFormatterFormatInstructionEx;
    ZydisFormatterFormatOperand = ZydisLib.ZydisFormatterFormatOperand;
    ZydisFormatterFormatOperandEx = ZydisLib.ZydisFormatterFormatOperandEx;
}

return exports