local ffi = require("ffi")

require("lj2zydis.DecoderTypes")
require("lj2zydis.Status")
require("lj2zydis.String")


ffi.cdef[[
typedef ZydisU8 ZydisFormatterStyle;


enum ZydisFormatterStyles
{
    ZYDIS_FORMATTER_STYLE_INTEL,
    ZYDIS_FORMATTER_STYLE_MAX_VALUE = ZYDIS_FORMATTER_STYLE_INTEL
};
]]

ffi.cdef[[
typedef ZydisU8 ZydisFormatterProperty;

enum ZydisFormatterProperties
{
    ZYDIS_FORMATTER_PROP_UPPERCASE,
    ZYDIS_FORMATTER_PROP_FORCE_MEMSEG,
    ZYDIS_FORMATTER_PROP_FORCE_MEMSIZE,
    ZYDIS_FORMATTER_PROP_ADDR_FORMAT,
    ZYDIS_FORMATTER_PROP_DISP_FORMAT,
    ZYDIS_FORMATTER_PROP_IMM_FORMAT,
    ZYDIS_FORMATTER_PROP_HEX_UPPERCASE,
    ZYDIS_FORMATTER_PROP_HEX_PREFIX,
    ZYDIS_FORMATTER_PROP_HEX_SUFFIX,
    ZYDIS_FORMATTER_PROP_HEX_PADDING_ADDR,
    ZYDIS_FORMATTER_PROP_HEX_PADDING_DISP,
    ZYDIS_FORMATTER_PROP_HEX_PADDING_IMM,

    ZYDIS_FORMATTER_PROP_MAX_VALUE = ZYDIS_FORMATTER_PROP_HEX_PADDING_IMM
};
]]

ffi.cdef[[

enum ZydisAddressFormat
{
    ZYDIS_ADDR_FORMAT_ABSOLUTE,
    ZYDIS_ADDR_FORMAT_RELATIVE_SIGNED,
    ZYDIS_ADDR_FORMAT_RELATIVE_UNSIGNED,

    ZYDIS_ADDR_FORMAT_MAX_VALUE = ZYDIS_ADDR_FORMAT_RELATIVE_UNSIGNED
};
]]


ffi.cdef[[

enum ZydisDisplacementFormat
{
    ZYDIS_DISP_FORMAT_HEX_SIGNED,
    ZYDIS_DISP_FORMAT_HEX_UNSIGNED,

    ZYDIS_DISP_FORMAT_MAX_VALUE = ZYDIS_DISP_FORMAT_HEX_UNSIGNED
};
]]

ffi.cdef[[

enum ZydisImmediateFormat
{
    ZYDIS_IMM_FORMAT_HEX_AUTO,
    ZYDIS_IMM_FORMAT_HEX_SIGNED,
    ZYDIS_IMM_FORMAT_HEX_UNSIGNED,

    ZYDIS_IMM_FORMAT_MAX_VALUE = ZYDIS_IMM_FORMAT_HEX_UNSIGNED
};
]]

ffi.cdef[[

typedef ZydisU8 ZydisFormatterHookType;

enum ZydisFormatterHookTypes
{
    ZYDIS_FORMATTER_HOOK_PRE_INSTRUCTION,
    ZYDIS_FORMATTER_HOOK_POST_INSTRUCTION,
    ZYDIS_FORMATTER_HOOK_PRE_OPERAND,
    ZYDIS_FORMATTER_HOOK_POST_OPERAND,
    ZYDIS_FORMATTER_HOOK_FORMAT_INSTRUCTION,
    ZYDIS_FORMATTER_HOOK_FORMAT_OPERAND_REG,
    ZYDIS_FORMATTER_HOOK_FORMAT_OPERAND_MEM,
    ZYDIS_FORMATTER_HOOK_FORMAT_OPERAND_PTR,
    ZYDIS_FORMATTER_HOOK_FORMAT_OPERAND_IMM,
    ZYDIS_FORMATTER_HOOK_PRINT_MNEMONIC,
    ZYDIS_FORMATTER_HOOK_PRINT_REGISTER,
    ZYDIS_FORMATTER_HOOK_PRINT_ADDRESS,
    ZYDIS_FORMATTER_HOOK_PRINT_DISP,
    ZYDIS_FORMATTER_HOOK_PRINT_IMM,
    ZYDIS_FORMATTER_HOOK_PRINT_MEMSIZE,
    ZYDIS_FORMATTER_HOOK_PRINT_PREFIXES,
    ZYDIS_FORMATTER_HOOK_PRINT_DECORATOR,

    ZYDIS_FORMATTER_HOOK_MAX_VALUE = ZYDIS_FORMATTER_HOOK_PRINT_DECORATOR
};
]]

ffi.cdef[[

typedef ZydisU8 ZydisDecoratorType;

enum ZydisDecoratorTypes
{
    ZYDIS_DECORATOR_TYPE_INVALID,
    ZYDIS_DECORATOR_TYPE_MASK,
    ZYDIS_DECORATOR_TYPE_BC,
    ZYDIS_DECORATOR_TYPE_RC,
    ZYDIS_DECORATOR_TYPE_SAE,
    ZYDIS_DECORATOR_TYPE_SWIZZLE,
    ZYDIS_DECORATOR_TYPE_CONVERSION,
    ZYDIS_DECORATOR_TYPE_EH,

    ZYDIS_DECORATOR_TYPE_MAX_VALUE = ZYDIS_DECORATOR_TYPE_EH
};
]]

ffi.cdef[[
typedef struct ZydisFormatter_ ZydisFormatter;


typedef ZydisStatus (*ZydisFormatterFunc)(const ZydisFormatter* formatter,
    ZydisString* string, const ZydisDecodedInstruction* instruction, void* userData);


typedef ZydisStatus (*ZydisFormatterOperandFunc)(const ZydisFormatter* formatter,
    ZydisString* string, const ZydisDecodedInstruction* instruction,
    const ZydisDecodedOperand* operand, void* userData);


typedef ZydisStatus (*ZydisFormatterRegisterFunc)(const ZydisFormatter* formatter,
    ZydisString* string, const ZydisDecodedInstruction* instruction,
    const ZydisDecodedOperand* operand, ZydisRegister reg, void* userData);


typedef ZydisStatus (*ZydisFormatterAddressFunc)(const ZydisFormatter* formatter,
    ZydisString* string, const ZydisDecodedInstruction* instruction,
    const ZydisDecodedOperand* operand, ZydisU64 address, void* userData);


typedef ZydisStatus (*ZydisFormatterDecoratorFunc)(const ZydisFormatter* formatter,
    ZydisString* string, const ZydisDecodedInstruction* instruction,
    const ZydisDecodedOperand* operand, ZydisDecoratorType decorator, void* userData);
]]

ffi.cdef[[

struct ZydisFormatter_
{
    ZydisLetterCase letterCase;
    ZydisBool forceMemorySegment;
    ZydisBool forceMemorySize;
    ZydisU8 formatAddress;
    ZydisU8 formatDisp;
    ZydisU8 formatImm;
    ZydisBool hexUppercase;
    ZydisString* hexPrefix;
    ZydisString hexPrefixData;
    ZydisString* hexSuffix;
    ZydisString hexSuffixData;
    ZydisU8 hexPaddingAddress;
    ZydisU8 hexPaddingDisp;
    ZydisU8 hexPaddingImm;
    ZydisFormatterFunc funcPreInstruction;
    ZydisFormatterFunc funcPostInstruction;
    ZydisFormatterOperandFunc funcPreOperand;
    ZydisFormatterOperandFunc funcPostOperand;
    ZydisFormatterFunc funcFormatInstruction;
    ZydisFormatterOperandFunc funcFormatOperandReg;
    ZydisFormatterOperandFunc funcFormatOperandMem;
    ZydisFormatterOperandFunc funcFormatOperandPtr;
    ZydisFormatterOperandFunc funcFormatOperandImm;
    ZydisFormatterFunc funcPrintMnemonic;
    ZydisFormatterRegisterFunc funcPrintRegister;
    ZydisFormatterAddressFunc funcPrintAddress;
    ZydisFormatterOperandFunc funcPrintDisp;
    ZydisFormatterOperandFunc funcPrintImm;
    ZydisFormatterOperandFunc funcPrintMemSize;
    ZydisFormatterFunc funcPrintPrefixes;
    ZydisFormatterDecoratorFunc funcPrintDecorator;
};
]]


ffi.cdef[[
 ZydisStatus ZydisFormatterInit(ZydisFormatter* formatter, ZydisFormatterStyle style);


 ZydisStatus ZydisFormatterSetProperty(ZydisFormatter* formatter,
    ZydisFormatterProperty property, ZydisUPointer value);


 ZydisStatus ZydisFormatterSetHook(ZydisFormatter* formatter,
    ZydisFormatterHookType hook, const void** callback);


 ZydisStatus ZydisFormatterFormatInstruction(const ZydisFormatter* formatter,
    const ZydisDecodedInstruction* instruction, char* buffer, ZydisUSize bufferLen);


 ZydisStatus ZydisFormatterFormatInstructionEx(const ZydisFormatter* formatter,
    const ZydisDecodedInstruction* instruction, char* buffer, ZydisUSize bufferLen, void* userData);


 ZydisStatus ZydisFormatterFormatOperand(const ZydisFormatter* formatter,
    const ZydisDecodedInstruction* instruction, ZydisU8 index, char* buffer, ZydisUSize bufferLen);


 ZydisStatus ZydisFormatterFormatOperandEx(const ZydisFormatter* formatter,
    const ZydisDecodedInstruction* instruction, ZydisU8 index, char* buffer, ZydisUSize bufferLen,
    void* userData);
]]



