local ffi = require("ffi")

require("lj2zydis.ffi.Status")
require("lj2zydis.ffi.DecoderTypes")

ffi.cdef[[

 ZydisStatus ZydisCalcAbsoluteAddress(const ZydisDecodedInstruction* instruction,
    const ZydisDecodedOperand* operand, ZydisU64* address);

 ZydisStatus ZydisGetAccessedFlagsByAction(const ZydisDecodedInstruction* instruction,
    ZydisCPUFlagAction action, ZydisCPUFlagMask* flags);
]]

