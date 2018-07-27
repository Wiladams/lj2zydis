local ffi = require("ffi")

ffi.cdef[[
    typedef uint8_t   ZydisU8;
    typedef uint16_t  ZydisU16;
    typedef uint32_t  ZydisU32;
    typedef uint64_t  ZydisU64;
    typedef int8_t    ZydisI8;
    typedef int16_t   ZydisI16;
    typedef int32_t   ZydisI32;
    typedef int64_t   ZydisI64;
    typedef size_t    ZydisUSize;
    typedef ptrdiff_t ZydisISize;
    typedef uintptr_t ZydisUPointer;
    typedef intptr_t  ZydisIPointer;

    typedef ZydisU8 ZydisBool;
    typedef ZydisU32 ZydisStatus;
]]

-- For decoder
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
typedef ZydisU8 ZydisMachineMode;

enum ZydisMachineModes
{
    ZYDIS_MACHINE_MODE_INVALID,
    ZYDIS_MACHINE_MODE_LONG_64,
    ZYDIS_MACHINE_MODE_LONG_COMPAT_32,
    ZYDIS_MACHINE_MODE_LONG_COMPAT_16,
    ZYDIS_MACHINE_MODE_LEGACY_32,
    ZYDIS_MACHINE_MODE_LEGACY_16,
    ZYDIS_MACHINE_MODE_REAL_16,

    ZYDIS_MACHINE_MODE_MAX_VALUE = ZYDIS_MACHINE_MODE_REAL_16
};
]]

ffi.cdef[[
typedef ZydisU8 ZydisAddressWidth;
enum ZydisAddressWidths
{
    ZYDIS_ADDRESS_WIDTH_INVALID         =  0,
    ZYDIS_ADDRESS_WIDTH_16              = 16,
    ZYDIS_ADDRESS_WIDTH_32              = 32,
    ZYDIS_ADDRESS_WIDTH_64              = 64,


    ZYDIS_ADDRESS_WIDTH_MAX_VALUE       = ZYDIS_ADDRESS_WIDTH_64
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
    typedef struct ZydisDecodedInstruction_
    {
        /**
         * @brief   The machine mode used to decode this instruction.
         */
        ZydisMachineMode machineMode;
        /**
         * @brief   The instruction-mnemonic.
         */
        ZydisMnemonic mnemonic;
        /**
         * @brief   The length of the decoded instruction.
         */
        ZydisU8 length;
        /**
         * @brief   The raw bytes of the decoded instruction.
         */
        ZydisU8 data[ZYDIS_MAX_INSTRUCTION_LENGTH];
        /**
         * @brief   The instruction-encoding (default, 3DNow, VEX, EVEX, XOP).
         */
        ZydisInstructionEncoding encoding;
        /**
         * @brief   The opcode-map.
         */
        ZydisOpcodeMap opcodeMap;
        /**
         * @brief   The instruction-opcode.
         */
        ZydisU8 opcode;
        /**
         * @brief   The stack width.
         */
        ZydisU8 stackWidth;
        /**
         * @brief   The effective operand width.
         */
        ZydisU8 operandWidth;
        /**
         * @brief   The effective address width.
         */
        ZydisU8 addressWidth;
        /**
         * @brief   The number of instruction-operands.
         */
        ZydisU8 operandCount;
        /**
         * @brief   Detailed info for all instruction operands.
         */
        ZydisDecodedOperand operands[ZYDIS_MAX_OPERAND_COUNT];
        /**
         * @brief  Instruction attributes.
         */
        ZydisInstructionAttributes attributes;
        /**
         * @brief   The instruction address points at the current instruction (based on the initial
         *          instruction pointer).
         */
        ZydisU64 instrAddress;
        /**
         * @brief   Information about accessed CPU flags.
         */
        struct
        {
            /**
             * @brief   The CPU-flag action.
             *
             * You can call `ZydisGetAccessedFlagsByAction` to get a mask with all flags matching a
             * specific action.
             */
            ZydisCPUFlagAction action;
        } accessedFlags[ZYDIS_CPUFLAG_MAX_VALUE + 1];
        /**
         * @brief   Extended info for AVX instructions.
         */
        struct
        {
            /**
             * @brief   The AVX vector-length.
             */
            ZydisVectorLength vectorLength;
            /**
             * @brief   Info about the embedded writemask-register (`AVX-512` and `KNC` only).
             */
            struct
            {
                /**
                 * @brief   The masking mode.
                 */
                ZydisMaskMode mode;
                /**
                 * @brief   The mask register.
                 */
                ZydisRegister reg;
                /**
                 * @brief   Signals, if the mask-register is used as a control mask.
                 */
                ZydisBool isControlMask;
            } mask;
            /**
             * @brief   Contains info about the AVX broadcast.
             */
            struct
            {
                /**
                 * @brief   Signals, if the broadcast is a static broadcast.
                 *
                 * This is the case for instructions with inbuild broadcast functionality, that is
                 * always active controlled by the `EVEX/MVEX.RC` bits.
                 */
                ZydisBool isStatic;
                /**
                 * @brief   The AVX broadcast-mode.
                 */
                ZydisBroadcastMode mode;
            } broadcast;
            /**
             * @brief   Contains info about the AVX rounding.
             */
            struct
            {
                /**
                 * @brief   The AVX rounding-mode.
                 */
                ZydisRoundingMode mode;
            } rounding;
            /**
             * @brief   Contains info about the AVX register-swizzle (`KNC` only).
             */
            struct
            {
                /**
                 * @brief   The AVX register-swizzle mode.
                 */
                ZydisSwizzleMode mode;
            } swizzle;
            /**
             * @brief   Contains info about the AVX data-conversion (`KNC` only).
             */
            struct
            {
                /**
                 * @brief   The AVX data-conversion mode.
                 */
                ZydisConversionMode mode;
            } conversion;
            /**
             * @brief   Signals, if the sae functionality is enabled for the instruction.
             */
            ZydisBool hasSAE;
            /**
             * @brief   Signals, if the instruction has a memory eviction-hint (`KNC` only).
             */
            ZydisBool hasEvictionHint;
            // TODO: publish EVEX tuple-type and MVEX functionality
        } avx;
        /**
         * @brief   Meta info.
         */
        struct
        {
            /**
             * @brief   The instruction category.
             */
            ZydisInstructionCategory category;
            /**
             * @brief   The ISA-set.
             */
            ZydisISASet isaSet;
            /**
             * @brief   The ISA-set extension.
             */
            ZydisISAExt isaExt;
            /**
             * @brief   The exception class.
             */
            ZydisExceptionClass exceptionClass;
        } meta;
        /**
         * @brief   Extended info about different instruction-parts like ModRM, SIB or
         *          encoding-prefixes.
         */
        struct
        {
            /**
             * @brief   Detailed info about the legacy prefixes
             */
            struct
            {
                ZydisU8 data[ZYDIS_MAX_INSTRUCTION_LENGTH - 1];
                ZydisU8 count;
                ZydisU8 hasF0;
                ZydisU8 hasF3;
                ZydisU8 hasF2;
                ZydisU8 has2E;
                ZydisU8 has36;
                ZydisU8 has3E;
                ZydisU8 has26;
                ZydisU8 has64;
                ZydisU8 has65;
                ZydisU8 has66;
                ZydisU8 has67;
            } prefixes;
            /**
             * @brief   Detailed info about the REX-prefix.
             */
            struct
            {
                /**
                 * @brief   @c TRUE if the prefix got already decoded.
                 */
                ZydisBool isDecoded;
                /**
                 * @brief   The raw bytes of the prefix.
                 */
                ZydisU8 data[1];
                /**
                 * @brief   64-bit operand-size promotion.
                 */
                ZydisU8 W;
                /**
                 * @brief   Extension of the ModRM.reg field.
                 */
                ZydisU8 R;
                /**
                 * @brief   Extension of the SIB.index field.
                 */
                ZydisU8 X;
                /**
                 * @brief   Extension of the ModRM.rm, SIB.base, or opcode.reg field.
                 */
                ZydisU8 B;
            } rex;
            /**
             * @brief   Detailed info about the XOP-prefix.
             */
            struct
            {
                /**
                 * @brief   @c TRUE if the prefix got already decoded.
                 */
                ZydisBool isDecoded;
                /**
                 * @brief   The raw bytes of the prefix.
                 */
                ZydisU8 data[3];
                /**
                 * @brief   Extension of the ModRM.reg field (inverted).
                 */
                ZydisU8 R;
                /**
                 * @brief   Extension of the SIB.index field (inverted).
                 */
                ZydisU8 X;
                /**
                 * @brief   Extension of the ModRM.rm, SIB.base, or opcode.reg field (inverted).
                 */
                ZydisU8 B;
                /**
                 * @brief   Opcode-map specifier.
                 */
                ZydisU8 m_mmmm;
                /**
                 * @brief   64-bit operand-size promotion or opcode-extension.
                 */
                ZydisU8 W;
                /**
                 * @brief   NDS register specifier (inverted).
                 */
                ZydisU8 vvvv;
                /**
                 * @brief   Vector-length specifier.
                 */
                ZydisU8 L;
                /**
                 * @brief   Compressed legacy prefix.
                 */
                ZydisU8 pp;
            } xop;
            /**
             * @brief   Detailed info about the VEX-prefix.
             */
            struct
            {
                /**
                 * @brief   @c TRUE if the prefix got already decoded.
                 */
                ZydisBool isDecoded;
                /**
                 * @brief   The raw bytes of the prefix.
                 */
                ZydisU8 data[3];
                /**
                 * @brief   Extension of the ModRM.reg field (inverted).
                 */
                ZydisU8 R;
                /**
                 * @brief   Extension of the SIB.index field (inverted).
                 */
                ZydisU8 X;
                /**
                 * @brief   Extension of the ModRM.rm, SIB.base, or opcode.reg field (inverted).
                 */
                ZydisU8 B;
                /**
                 * @brief   Opcode-map specifier.
                 */
                ZydisU8 m_mmmm;
                /**
                 * @brief   64-bit operand-size promotion or opcode-extension.
                 */
                ZydisU8 W;
                /**
                 * @brief   NDS register specifier (inverted).
                 */
                ZydisU8 vvvv;
                /**
                 * @brief   Vector-length specifier.
                 */
                ZydisU8 L;
                /**
                 * @brief   Compressed legacy prefix.
                 */
                ZydisU8 pp;
            } vex;
            /**
             * @brief   Detailed info about the EVEX-prefix.
             */
            struct
            {
                /**
                 * @brief   @c TRUE if the prefix got already decoded.
                 */
                ZydisBool isDecoded;
                /**
                 * @brief   The raw bytes of the prefix.
                 */
                ZydisU8 data[4];
                /**
                 * @brief   Extension of the ModRM.reg field (inverted).
                 */
                ZydisU8 R;
                /**
                 * @brief   Extension of the SIB.index/vidx field (inverted).
                 */
                ZydisU8 X;
                /**
                 * @brief   Extension of the ModRM.rm or SIB.base field (inverted).
                 */
                ZydisU8 B;
                /**
                 * @brief   High-16 register specifier modifier (inverted).
                 */
                ZydisU8 R2;
                /**
                 * @brief   Opcode-map specifier.
                 */
                ZydisU8 mm;
                /**
                 * @brief   64-bit operand-size promotion or opcode-extension.
                 */
                ZydisU8 W;
                /**
                 * @brief   NDS register specifier (inverted).
                 */
                ZydisU8 vvvv;
                /**
                 * @brief   Compressed legacy prefix.
                 */
                ZydisU8 pp;
                /**
                 * @brief   Zeroing/Merging.
                 */
                ZydisU8 z;
                /**
                 * @brief   Vector-length specifier or rounding-control (most significant bit).
                 */
                ZydisU8 L2;
                /**
                 * @brief   Vector-length specifier or rounding-control (least significant bit).
                 */
                ZydisU8 L;
                /**
                 * @brief   Broadcast/RC/SAE Context.
                 */
                ZydisU8 b;
                /**
                 * @brief   High-16 NDS/VIDX register specifier.
                 */
                ZydisU8 V2;
                /**
                 * @brief   Embedded opmask register specifier.
                 */
                ZydisU8 aaa;
            } evex;
            /**
            * @brief    Detailed info about the MVEX-prefix.
            */
            struct
            {
                /**
                 * @brief   @c TRUE if the prefix got already decoded.
                 */
                ZydisBool isDecoded;
                /**
                 * @brief   The raw bytes of the prefix.
                 */
                ZydisU8 data[4];
                /**
                 * @brief   Extension of the ModRM.reg field (inverted).
                 */
                ZydisU8 R;
                /**
                 * @brief   Extension of the SIB.index/vidx field (inverted).
                 */
                ZydisU8 X;
                /**
                 * @brief   Extension of the ModRM.rm or SIB.base field (inverted).
                 */
                ZydisU8 B;
                /**
                 * @brief   High-16 register specifier modifier (inverted).
                 */
                ZydisU8 R2;
                /**
                 * @brief   Opcode-map specifier.
                 */
                ZydisU8 mmmm;
                /**
                 * @brief   64-bit operand-size promotion or opcode-extension.
                 */
                ZydisU8 W;
                /**
                 * @brief   NDS register specifier (inverted).
                 */
                ZydisU8 vvvv;
                /**
                 * @brief   Compressed legacy prefix.
                 */
                ZydisU8 pp;
                /**
                 * @brief   Non-temporal/eviction hint.
                 */
                ZydisU8 E;
                /**
                 * @brief   Swizzle/broadcast/up-convert/down-convert/static-rounding controls.
                 */
                ZydisU8 SSS;
                /**
                 * @brief   High-16 NDS/VIDX register specifier.
                 */
                ZydisU8 V2;
                /**
                 * @brief   Embedded opmask register specifier.
                 */
                ZydisU8 kkk;
            } mvex;
            /**
             * @brief   Detailed info about the ModRM-byte.
             */
            struct
            {
                ZydisBool isDecoded;
                ZydisU8 data[1];
                ZydisU8 mod;
                ZydisU8 reg;
                ZydisU8 rm;
            } modrm;
            /**
             * @brief   Detailed info about the SIB-byte.
             */
            struct
            {
                ZydisBool isDecoded;
                ZydisU8 data[1];
                ZydisU8 scale;
                ZydisU8 index;
                ZydisU8 base;
            } sib;
            /**
             * @brief   Detailed info about displacement-bytes.
             */
            struct
            {
                /**
                 * @brief   The displacement value
                 */
                ZydisI64 value;
                /**
                 * @brief   The physical displacement size, in bits.
                 */
                ZydisU8 size;
                // TODO: publish cd8 scale
                /**
                 * @brief   The offset of the displacement data, relative to the beginning of the
                 *          instruction, in bytes.
                 */
                ZydisU8 offset;
            } disp;
            /**
             * @brief   Detailed info about immediate-bytes.
             */
            struct
            {
                ZydisBool isSigned;
                ZydisBool isRelative;

                union
                {
                    ZydisU64 u;
                    ZydisI64 s;
                } value;

                ZydisU8 size;
                ZydisU8 offset;
            } imm[2];
        } raw;
    } ZydisDecodedInstruction;
]]

ffi.cdef[[
ZydisStatus ZydisDecoderInit(ZydisDecoder* decoder, ZydisMachineMode machineMode, ZydisAddressWidth addressWidth);
ZydisStatus ZydisDecoderEnableMode(ZydisDecoder* decoder, ZydisDecoderMode mode, ZydisBool enabled);

ZydisStatus ZydisDecoderDecodeBuffer(const ZydisDecoder* decoder, const void* buffer, ZydisUSize bufferLen, ZydisU64 instructionPointer, ZydisDecodedInstruction* instruction);
]]

ffi.cdef[[
ZydisBool ZydisIsFeatureEnabled(ZydisFeature feature);
ZydisU64 ZydisGetVersion(void);

]]

local ZydisStatusCodes = {
    ZYDIS_STATUS_SUCCESS             = 0x00000000,
    ZYDIS_STATUS_INVALID_PARAMETER = 1,
    ZYDIS_STATUS_INVALID_OPERATION = 2,
    ZYDIS_STATUS_INSUFFICIENT_BUFFER_SIZE = 3,

    -- Decoder
    ZYDIS_STATUS_NO_MORE_DATA = 4,
    ZYDIS_STATUS_DECODING_ERROR = 5,
    ZYDIS_STATUS_INSTRUCTION_TOO_LONG = 6,
    ZYDIS_STATUS_BAD_REGISTER = 7,
    ZYDIS_STATUS_ILLEGAL_LOCK = 8,
    ZYDIS_STATUS_ILLEGAL_LEGACY_PFX = 9,
    ZYDIS_STATUS_ILLEGAL_REX = 10,
    ZYDIS_STATUS_INVALID_MAP = 11,
    ZYDIS_STATUS_MALFORMED_EVEX = 12,
    ZYDIS_STATUS_MALFORMED_MVEX = 13,
    ZYDIS_STATUS_INVALID_MASK = 14,


    -- Formatter
    ZYDIS_STATUS_SKIP_OPERAND = 15,

    -- Encoder
    ZYDIS_STATUS_IMPOSSIBLE_INSTRUCTION = 16,

    -- Misc
    ZYDIS_STATUS_USER = 0x10000000
};

local ZydisLib = ffi.load("zydis");

local exports = {
    Lib = ZydisLib;

    ZydisGetVersion = ZydisLib.ZydisGetVersion;
}

return exports