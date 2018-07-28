local ffi = require("ffi")

require("lj2zydis.CommonTypes")
require("lj2zydis.DecoderTypes")
require("lj2zydis.Status")

ffi.cdef[[
typedef ZydisU8 ZydisDecoderMode;
]]

ffi.cdef[[
enum ZydisDecoderModes
{
    ZYDIS_DECODER_MODE_MINIMAL,
    ZYDIS_DECODER_MODE_AMD_BRANCHES,
    ZYDIS_DECODER_MODE_KNC,
    ZYDIS_DECODER_MODE_MPX,
    ZYDIS_DECODER_MODE_CET,
    ZYDIS_DECODER_MODE_LZCNT,
    ZYDIS_DECODER_MODE_TZCNT,
    ZYDIS_DECODER_MODE_WBNOINVD,

    ZYDIS_DECODER_MODE_MAX_VALUE = ZYDIS_DECODER_MODE_WBNOINVD
};
]]

ffi.cdef[[
    typedef struct ZydisDecoder_
{
    ZydisMachineMode machineMode;
    ZydisAddressWidth addressWidth;
    ZydisBool decoderMode[ZYDIS_DECODER_MODE_MAX_VALUE + 1];
} ZydisDecoder;
]]

ffi.cdef[[
ZydisStatus ZydisDecoderInit(ZydisDecoder* decoder, ZydisMachineMode machineMode, ZydisAddressWidth addressWidth);
ZydisStatus ZydisDecoderEnableMode(ZydisDecoder* decoder, ZydisDecoderMode mode, ZydisBool enabled);
ZydisStatus ZydisDecoderDecodeBuffer(const ZydisDecoder* decoder, const void* buffer, ZydisUSize bufferLen, ZydisU64 instructionPointer, ZydisDecodedInstruction* instruction);
]]

