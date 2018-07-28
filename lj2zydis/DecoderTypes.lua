local ffi = require("ffi")

require("lj2zydis.CommonTypes")
require("lj2zydis.MetaInfo")
require("lj2zydis.Mnemonic")
require("lj2zydis.Register")
require("lj2zydis.SharedTypes")

ffi.cdef[[
typedef ZydisU8 ZydisMemoryOperandType;
]]

ffi.cdef[[
    enum ZydisMemoryOperandTypes
{
    ZYDIS_MEMOP_TYPE_INVALID,
    ZYDIS_MEMOP_TYPE_MEM,
    ZYDIS_MEMOP_TYPE_AGEN,
    ZYDIS_MEMOP_TYPE_MIB,

    ZYDIS_MEMOP_TYPE_MAX_VALUE = ZYDIS_MEMOP_TYPE_MIB
};
]]

ffi.cdef[[
typedef struct ZydisDecodedOperand_
{
    /**
     * @brief   The operand-id.
     */
    ZydisU8 id;
    /**
     * @brief   The type of the operand.
     */
    ZydisOperandType type;
    /**
     * @brief   The visibility of the operand.
     */
    ZydisOperandVisibility visibility;
    /**
     * @brief   The operand-action.
     */
    ZydisOperandAction action;
    /**
     * @brief   The operand-encoding.
     */
    ZydisOperandEncoding encoding;
    /**
     * @brief   The logical size of the operand (in bits).
     */
    ZydisU16 size;
    /**
     * @brief   The element-type.
     */
    ZydisElementType elementType;
    /**
     * @brief   The size of a single element.
     */
    ZydisElementSize elementSize;
    /**
     * @brief   The number of elements.
     */
    ZydisU16 elementCount;
    /**
     * @brief   Extended info for register-operands.
     */
    struct
    {
        /**
         * @brief   The register value.
         */
        ZydisRegister value;
        // TODO: AVX512_4VNNIW MULTISOURCE registers
    } reg;
    /**
     * @brief   Extended info for memory-operands.
     */
    struct
    {
        /**
         * @brief   The type of the memory operand.
         */
        ZydisMemoryOperandType type;
        /**
         * @brief   The segment register.
         */
        ZydisRegister segment;
        /**
         * @brief   The base register.
         */
        ZydisRegister base;
        /**
         * @brief   The index register.
         */
        ZydisRegister index;
        /**
         * @brief   The scale factor.
         */
        ZydisU8 scale;
        /**
         * @brief   Extended info for memory-operands with displacement.
         */
        struct
        {
            /**
             * @brief   Signals, if the displacement value is used.
             */
            ZydisBool hasDisplacement;
            /**
             * @brief   The displacement value
             */
            ZydisI64 value;
        } disp;
    } mem;
    /**
     * @brief   Extended info for pointer-operands.
     */
    struct
    {
        ZydisU16 segment;
        ZydisU32 offset;
    } ptr;
    /**
     * @brief   Extended info for immediate-operands.
     */
    struct
    {
        /**
         * @brief   Signals, if the immediate value is signed.
         */
        ZydisBool isSigned;
        /**
         * @brief   Signals, if the immediate value contains a relative offset. You can use
         *          @c ZydisCalcAbsoluteAddress to determine the absolute address value.
         */
        ZydisBool isRelative;
        /**
         * @brief   The immediate value.
         */
        union
        {
            ZydisU64 u;
            ZydisI64 s;
        } value;
    } imm;
} ZydisDecodedOperand;
]]

ffi.cdef[[
typedef ZydisU64 ZydisInstructionAttributes;
]]


--   The instruction has the ModRM byte.
local ZYDIS_INSTRUCTION_ATTRIBUTE = {
ZYDIS_ATTRIB_HAS_MODRM                =  0x0000000000000001ULL; -- (1 <<  0)

 ZYDIS_ATTRIB_HAS_SIB                    = 0x0000000000000002; --(1 <<  1)

 ZYDIS_ATTRIB_HAS_REX                    = 0x0000000000000004; --(1 <<  2)

 ZYDIS_ATTRIB_HAS_XOP                    = 0x0000000000000008; --(1 <<  3)

 ZYDIS_ATTRIB_HAS_VEX                    = 0x0000000000000010; --(1 <<  4)

 ZYDIS_ATTRIB_HAS_EVEX                   = 0x0000000000000020; --(1 <<  5)

 ZYDIS_ATTRIB_HAS_MVEX                   = 0x0000000000000040; --(1 <<  6)

 ZYDIS_ATTRIB_IS_RELATIVE                = 0x0000000000000080; --(1 <<  7)

 ZYDIS_ATTRIB_IS_PRIVILEGED              = 0x0000000000000100; --(1 <<  8)

 ZYDIS_ATTRIB_IS_FAR_BRANCH              = 0x0000001000000000; --(1 << 36);

 ZYDIS_ATTRIB_ACCEPTS_LOCK               = 0x0000000000000200; --(1 <<  9)

 ZYDIS_ATTRIB_ACCEPTS_REP                = 0x0000000000000400; --(1 << 10)

 ZYDIS_ATTRIB_ACCEPTS_REPE               = 0x0000000000000800; --(1 << 11)

 ZYDIS_ATTRIB_ACCEPTS_REPZ               = 0x0000000000000800; --(1 << 11)

 ZYDIS_ATTRIB_ACCEPTS_REPNE              = 0x0000000000001000; --(1 << 12)

 ZYDIS_ATTRIB_ACCEPTS_REPNZ              = 0x0000000000001000; --(1 << 12)

 ZYDIS_ATTRIB_ACCEPTS_BOUND              = 0x0000000000002000; --(1 << 13)

 ZYDIS_ATTRIB_ACCEPTS_XACQUIRE           = 0x0000000000004000; --(1 << 14)

 ZYDIS_ATTRIB_ACCEPTS_XRELEASE           = 0x0000000000008000; --(1 << 15)

 ZYDIS_ATTRIB_ACCEPTS_HLE_WITHOUT_LOCK   = 0x0000000000010000; --(1 << 16)

 ZYDIS_ATTRIB_ACCEPTS_BRANCH_HINTS       = 0x0000000000020000; --(1 << 17)

 ZYDIS_ATTRIB_ACCEPTS_SEGMENT            = 0x0000000000040000; --(1 << 18)

 ZYDIS_ATTRIB_HAS_LOCK                   = 0x0000000000080000; --(1 << 19)

 ZYDIS_ATTRIB_HAS_REP                    = 0x0000000000100000; --(1 << 20)

 ZYDIS_ATTRIB_HAS_REPE                   = 0x0000000000200000; --(1 << 21)

 ZYDIS_ATTRIB_HAS_REPZ                   = 0x0000000000200000; --(1 << 21)

 ZYDIS_ATTRIB_HAS_REPNE                  = 0x0000000000400000; --(1 << 22)

 ZYDIS_ATTRIB_HAS_REPNZ                  = 0x0000000000400000; --(1 << 22)

 ZYDIS_ATTRIB_HAS_BOUND                  = 0x0000000000800000; --(1 << 23)

 ZYDIS_ATTRIB_HAS_XACQUIRE               = 0x0000000001000000; --(1 << 24)

 ZYDIS_ATTRIB_HAS_XRELEASE               = 0x0000000002000000; --(1 << 25)

 ZYDIS_ATTRIB_HAS_BRANCH_NOT_TAKEN       = 0x0000000004000000; --(1 << 26)

 ZYDIS_ATTRIB_HAS_BRANCH_TAKEN           = 0x0000000008000000; --(1 << 27)

 ZYDIS_ATTRIB_HAS_SEGMENT                = 0x00000003F0000000;

 ZYDIS_ATTRIB_HAS_SEGMENT_CS             = 0x0000000010000000; --(1 << 28)

 ZYDIS_ATTRIB_HAS_SEGMENT_SS             = 0x0000000020000000; --(1 << 29)

 ZYDIS_ATTRIB_HAS_SEGMENT_DS             = 0x0000000040000000; --(1 << 30)

 ZYDIS_ATTRIB_HAS_SEGMENT_ES             = 0x0000000080000000; --(1 << 31)

 ZYDIS_ATTRIB_HAS_SEGMENT_FS             = 0x0000000100000000; --(1 << 32)

 ZYDIS_ATTRIB_HAS_SEGMENT_GS             = 0x0000000200000000; --(1 << 33)

 ZYDIS_ATTRIB_HAS_OPERANDSIZE            = 0x0000000400000000; --(1 << 34);

 ZYDIS_ATTRIB_HAS_ADDRESSSIZE            = 0x0000000800000000; --(1 << 35);
}

ffi.cdef[[

typedef ZydisU8 ZydisCPUFlag;

/**
 * @brief   Defines the @c ZydisCPUFlagMask datatype.
 */
typedef ZydisU32 ZydisCPUFlagMask;

/**
 * @brief   Values that represent CPU-flags.
 */
enum ZydisCPUFlags
{
    /**
     * @brief   Carry flag.
     */
    ZYDIS_CPUFLAG_CF,
    /**
     * @brief   Parity flag.
     */
    ZYDIS_CPUFLAG_PF,
    /**
     * @brief   Adjust flag.
     */
    ZYDIS_CPUFLAG_AF,
    /**
     * @brief   Zero flag.
     */
    ZYDIS_CPUFLAG_ZF,
    /**
     * @brief   Sign flag.
     */
    ZYDIS_CPUFLAG_SF,
    /**
     * @brief   Trap flag.
     */
    ZYDIS_CPUFLAG_TF,
    /**
     * @brief   Interrupt enable flag.
     */
    ZYDIS_CPUFLAG_IF,
    /**
     * @brief   Direction flag.
     */
    ZYDIS_CPUFLAG_DF,
    /**
     * @brief   Overflow flag.
     */
    ZYDIS_CPUFLAG_OF,
    /**
     * @brief   I/O privilege level flag.
     */
    ZYDIS_CPUFLAG_IOPL,
    /**
     * @brief   Nested task flag.
     */
    ZYDIS_CPUFLAG_NT,
    /**
     * @brief   Resume flag.
     */
    ZYDIS_CPUFLAG_RF,
    /**
     * @brief   Virtual 8086 mode flag.
     */
    ZYDIS_CPUFLAG_VM,
    /**
     * @brief   Alignment check.
     */
    ZYDIS_CPUFLAG_AC,
    /**
     * @brief   Virtual interrupt flag.
     */
    ZYDIS_CPUFLAG_VIF,
    /**
     * @brief   Virtual interrupt pending.
     */
    ZYDIS_CPUFLAG_VIP,
    /**
     * @brief   Able to use CPUID instruction.
     */
    ZYDIS_CPUFLAG_ID,
    /**
     * @brief   FPU condition-code flag 0.
     */
    ZYDIS_CPUFLAG_C0,
    /**
     * @brief   FPU condition-code flag 1.
     */
    ZYDIS_CPUFLAG_C1,
    /**
     * @brief   FPU condition-code flag 2.
     */
    ZYDIS_CPUFLAG_C2,
    /**
     * @brief   FPU condition-code flag 3.
     */
    ZYDIS_CPUFLAG_C3,

    /**
     * @brief   Maximum value of this enum.
     */
    ZYDIS_CPUFLAG_MAX_VALUE = ZYDIS_CPUFLAG_C3
};
]]

ffi.cdef[[
/**
 * @brief   Defines the @c ZydisCPUFlagAction datatype.
 */
typedef ZydisU8 ZydisCPUFlagAction;

/**
 * @brief   Values that represent CPU-flag actions.
 */
enum ZydisCPUFlagActions
{
    /**
     * @brief   The CPU flag is not touched by the instruction.
     */
    ZYDIS_CPUFLAG_ACTION_NONE,
    /**
     * @brief   The CPU flag is tested (read).
     */
    ZYDIS_CPUFLAG_ACTION_TESTED,
    /**
     * @brief   The CPU flag is tested and modified aferwards (read-write).
     */
    ZYDIS_CPUFLAG_ACTION_TESTED_MODIFIED,
    /**
     * @brief   The CPU flag is modified (write).
     */
    ZYDIS_CPUFLAG_ACTION_MODIFIED,
    /**
     * @brief   The CPU flag is set to 0 (write).
     */
    ZYDIS_CPUFLAG_ACTION_SET_0,
    /**
     * @brief   The CPU flag is set to 1 (write).
     */
    ZYDIS_CPUFLAG_ACTION_SET_1,
    /**
     * @brief   The CPU flag is undefined (write).
     */
    ZYDIS_CPUFLAG_ACTION_UNDEFINED,

    /**
     * @brief   Maximum value of this enum.
     */
    ZYDIS_CPUFLAG_ACTION_MAX_VALUE = ZYDIS_CPUFLAG_ACTION_UNDEFINED
};
]]

ffi.cdef[[
/**
 * @brief   Defines the @c ZydisExceptionClass datatype.
 */
typedef ZydisU8 ZydisExceptionClass;

/**
 * @brief   Values that represent exception-classes.
 */
enum ZydisExceptionClasses
{
    ZYDIS_EXCEPTION_CLASS_NONE,
    // TODO: FP Exceptions
    ZYDIS_EXCEPTION_CLASS_SSE1,
    ZYDIS_EXCEPTION_CLASS_SSE2,
    ZYDIS_EXCEPTION_CLASS_SSE3,
    ZYDIS_EXCEPTION_CLASS_SSE4,
    ZYDIS_EXCEPTION_CLASS_SSE5,
    ZYDIS_EXCEPTION_CLASS_SSE7,
    ZYDIS_EXCEPTION_CLASS_AVX1,
    ZYDIS_EXCEPTION_CLASS_AVX2,
    ZYDIS_EXCEPTION_CLASS_AVX3,
    ZYDIS_EXCEPTION_CLASS_AVX4,
    ZYDIS_EXCEPTION_CLASS_AVX5,
    ZYDIS_EXCEPTION_CLASS_AVX6,
    ZYDIS_EXCEPTION_CLASS_AVX7,
    ZYDIS_EXCEPTION_CLASS_AVX8,
    ZYDIS_EXCEPTION_CLASS_AVX11,
    ZYDIS_EXCEPTION_CLASS_AVX12,
    ZYDIS_EXCEPTION_CLASS_E1,
    ZYDIS_EXCEPTION_CLASS_E1NF,
    ZYDIS_EXCEPTION_CLASS_E2,
    ZYDIS_EXCEPTION_CLASS_E2NF,
    ZYDIS_EXCEPTION_CLASS_E3,
    ZYDIS_EXCEPTION_CLASS_E3NF,
    ZYDIS_EXCEPTION_CLASS_E4,
    ZYDIS_EXCEPTION_CLASS_E4NF,
    ZYDIS_EXCEPTION_CLASS_E5,
    ZYDIS_EXCEPTION_CLASS_E5NF,
    ZYDIS_EXCEPTION_CLASS_E6,
    ZYDIS_EXCEPTION_CLASS_E6NF,
    ZYDIS_EXCEPTION_CLASS_E7NM,
    ZYDIS_EXCEPTION_CLASS_E7NM128,
    ZYDIS_EXCEPTION_CLASS_E9NF,
    ZYDIS_EXCEPTION_CLASS_E10,
    ZYDIS_EXCEPTION_CLASS_E10NF,
    ZYDIS_EXCEPTION_CLASS_E11,
    ZYDIS_EXCEPTION_CLASS_E11NF,
    ZYDIS_EXCEPTION_CLASS_E12,
    ZYDIS_EXCEPTION_CLASS_E12NP,
    ZYDIS_EXCEPTION_CLASS_K20,
    ZYDIS_EXCEPTION_CLASS_K21,

    /**
     * @brief   Maximum value of this enum.
     */
    ZYDIS_EXCEPTION_CLASS_MAX_VALUE = ZYDIS_EXCEPTION_CLASS_K21
};
]]

ffi.cdef[[
typedef ZydisU16 ZydisVectorLength;

enum ZydisVectorLengths
{
    ZYDIS_VECTOR_LENGTH_INVALID =   0,
    ZYDIS_VECTOR_LENGTH_128     = 128,
    ZYDIS_VECTOR_LENGTH_256     = 256,
    ZYDIS_VECTOR_LENGTH_512     = 512,

    /**
     * @brief   Maximum value of this enum.
     */
    ZYDIS_VECTOR_LENGTH_MAX_VALUE = ZYDIS_VECTOR_LENGTH_512
};
]]

ffi.cdef[[
typedef ZydisU8 ZydisMaskMode;


enum ZydisMaskModes
{
    ZYDIS_MASK_MODE_INVALID,
    ZYDIS_MASK_MODE_MERGE,
    ZYDIS_MASK_MODE_ZERO,


    ZYDIS_MASK_MODE_MAX_VALUE = ZYDIS_MASK_MODE_ZERO
};
]]

ffi.cdef[[
typedef ZydisU8 ZydisBroadcastMode;


enum ZydisBroadcastModes
{
    ZYDIS_BROADCAST_MODE_INVALID,
    ZYDIS_BROADCAST_MODE_1_TO_2,
    ZYDIS_BROADCAST_MODE_1_TO_4,
    ZYDIS_BROADCAST_MODE_1_TO_8,
    ZYDIS_BROADCAST_MODE_1_TO_16,
    ZYDIS_BROADCAST_MODE_1_TO_32,
    ZYDIS_BROADCAST_MODE_1_TO_64,
    ZYDIS_BROADCAST_MODE_2_TO_4,
    ZYDIS_BROADCAST_MODE_2_TO_8,
    ZYDIS_BROADCAST_MODE_2_TO_16,
    ZYDIS_BROADCAST_MODE_4_TO_8,
    ZYDIS_BROADCAST_MODE_4_TO_16,
    ZYDIS_BROADCAST_MODE_8_TO_16,


    ZYDIS_BROADCAST_MODE_MAX_VALUE = ZYDIS_BROADCAST_MODE_8_TO_16
};
]]

ffi.cdef[[

typedef ZydisU8 ZydisRoundingMode;


enum ZydisRoundingModes
{
    ZYDIS_ROUNDING_MODE_INVALID,
    ZYDIS_ROUNDING_MODE_RN,
    ZYDIS_ROUNDING_MODE_RD,
    ZYDIS_ROUNDING_MODE_RU,
    ZYDIS_ROUNDING_MODE_RZ,


    ZYDIS_ROUNDING_MODE_MAX_VALUE = ZYDIS_ROUNDING_MODE_RZ
};
]]

ffi.cdef[[

typedef ZydisU8 ZydisSwizzleMode;


enum ZydisSwizzleModes
{
    ZYDIS_SWIZZLE_MODE_INVALID,
    ZYDIS_SWIZZLE_MODE_DCBA,
    ZYDIS_SWIZZLE_MODE_CDAB,
    ZYDIS_SWIZZLE_MODE_BADC,
    ZYDIS_SWIZZLE_MODE_DACB,
    ZYDIS_SWIZZLE_MODE_AAAA,
    ZYDIS_SWIZZLE_MODE_BBBB,
    ZYDIS_SWIZZLE_MODE_CCCC,
    ZYDIS_SWIZZLE_MODE_DDDD,

    ZYDIS_SWIZZLE_MODE_MAX_VALUE = ZYDIS_SWIZZLE_MODE_DDDD
};
]]

ffi.cdef[[

typedef ZydisU8 ZydisConversionMode;

enum ZydisConversionModes
{
    ZYDIS_CONVERSION_MODE_INVALID,
    ZYDIS_CONVERSION_MODE_FLOAT16,
    ZYDIS_CONVERSION_MODE_SINT8,
    ZYDIS_CONVERSION_MODE_UINT8,
    ZYDIS_CONVERSION_MODE_SINT16,
    ZYDIS_CONVERSION_MODE_UINT16,

    ZYDIS_CONVERSION_MODE_MAX_VALUE = ZYDIS_CONVERSION_MODE_UINT16
};
]]

ffi.cdef[[
 typedef struct ZydisDecodedInstruction_
 {

     ZydisMachineMode machineMode;

     ZydisMnemonic mnemonic;

     ZydisU8 length;

     ZydisU8 data[ZYDIS_MAX_INSTRUCTION_LENGTH];

     ZydisInstructionEncoding encoding;

     ZydisOpcodeMap opcodeMap;

     ZydisU8 opcode;

     ZydisU8 stackWidth;

     ZydisU8 operandWidth;

     ZydisU8 addressWidth;

     ZydisU8 operandCount;

     ZydisDecodedOperand operands[ZYDIS_MAX_OPERAND_COUNT];

     ZydisInstructionAttributes attributes;

     ZydisU64 instrAddress;

     struct
     {
         ZydisCPUFlagAction action;
     } accessedFlags[ZYDIS_CPUFLAG_MAX_VALUE + 1];

     struct
     {

         ZydisVectorLength vectorLength;

         struct
         {
             ZydisMaskMode mode;
             ZydisRegister reg;
             ZydisBool isControlMask;
         } mask;

         struct
         {
             ZydisBool isStatic;
             ZydisBroadcastMode mode;
         } broadcast;

         struct
         {
             ZydisRoundingMode mode;
         } rounding;

         struct
         {
             ZydisSwizzleMode mode;
         } swizzle;

         struct
         {
             ZydisConversionMode mode;
         } conversion;

         ZydisBool hasSAE;
         ZydisBool hasEvictionHint;
     } avx;

     struct
     {
         ZydisInstructionCategory category;
         ZydisISASet isaSet;
         ZydisISAExt isaExt;
         ZydisExceptionClass exceptionClass;
     } meta;

     struct
     {
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

         struct
         {
             ZydisBool isDecoded;
             ZydisU8 data[1];
             ZydisU8 W;
             ZydisU8 R;
             ZydisU8 X;
             ZydisU8 B;
         } rex;

         struct
         {
             ZydisBool isDecoded;
             ZydisU8 data[3];
             ZydisU8 R;
             ZydisU8 X;
             ZydisU8 B;
             ZydisU8 m_mmmm;
             ZydisU8 W;
             ZydisU8 vvvv;
             ZydisU8 L;
             ZydisU8 pp;
         } xop;

         struct
         {
             ZydisBool isDecoded;
             ZydisU8 data[3];
             ZydisU8 R;
             ZydisU8 X;
             ZydisU8 B;
             ZydisU8 m_mmmm;
             ZydisU8 W;
             ZydisU8 vvvv;
             ZydisU8 L;
             ZydisU8 pp;
         } vex;

         struct
         {
             ZydisBool isDecoded;
             ZydisU8 data[4];
             ZydisU8 R;
             ZydisU8 X;
             ZydisU8 B;
             ZydisU8 R2;
             ZydisU8 mm;
             ZydisU8 W;
             ZydisU8 vvvv;
             ZydisU8 pp;
             ZydisU8 z;
             ZydisU8 L2;
             ZydisU8 L;
             ZydisU8 b;
             ZydisU8 V2;
             ZydisU8 aaa;
         } evex;

         struct
         {
             ZydisBool isDecoded;
             ZydisU8 data[4];
             ZydisU8 R;
             ZydisU8 X;
             ZydisU8 B;
             ZydisU8 R2;
             ZydisU8 mmmm;
             ZydisU8 W;
             ZydisU8 vvvv;
             ZydisU8 pp;
             ZydisU8 E;
             ZydisU8 SSS;
             ZydisU8 V2;
             ZydisU8 kkk;
         } mvex;

         struct
         {
             ZydisBool isDecoded;
             ZydisU8 data[1];
             ZydisU8 mod;
             ZydisU8 reg;
             ZydisU8 rm;
         } modrm;

         struct
         {
             ZydisBool isDecoded;
             ZydisU8 data[1];
             ZydisU8 scale;
             ZydisU8 index;
             ZydisU8 base;
         } sib;

         struct
         {
             ZydisI64 value;
             ZydisU8 size;
             ZydisU8 offset;
         } disp;

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
