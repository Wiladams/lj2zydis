return {
operandTypes = 
{
    [0] = "UNUSED",
    "REGISTER",
    "MEMORY",
    "POINTER",
    "IMMEDIATE"
};

operandVisibilities = 
{
    [0] = "INVALID",
    "EXPLICIT",
    "IMPLICIT",
    "HIDDEN"
};

operandActions =
{
    [0] = "INV",
    "R",
    "W",
    "RW",
    "CR",
    "CW",
    "RCW",
    "CRW"
};

elementTypes = 
{
    [0] = "INVALID",
    "STRUCT",
    "UINT",
    "INT",
    "FLOAT16",
    "FLOAT32",
    "FLOAT64",
    "FLOAT80",
    "LONGBCD"
};

operandEncodings = 
{
    [0] = "NONE",
    "MODRM_REG",
    "MODRM_RM",
    "OPCODE",
    "NDSNDD",
    "IS4",
    "MASK",
    "DISP8",
    "DISP16",
    "DISP32",
    "DISP64",
    "DISP16_32_64",
    "DISP32_32_64",
    "DISP16_32_32",
    "UIMM8",
    "UIMM16",
    "UIMM32",
    "UIMM64",
    "UIMM16_32_64",
    "UIMM32_32_64",
    "UIMM16_32_32",
    "SIMM8",
    "SIMM16",
    "SIMM32",
    "SIMM64",
    "SIMM16_32_64",
    "SIMM32_32_64",
    "SIMM16_32_32",
    "JIMM8",
    "JIMM16",
    "JIMM32",
    "JIMM64",
    "JIMM16_32_64",
    "JIMM32_32_64",
    "JIMM16_32_32"
};

memopTypes =  
{
    [0] = "INVALID",
    "MEM",
    "AGEN",
    "MIB"
};

StatusStrings =
{
    [0] = "SUCCESS",
    "INVALID_PARAMETER",
    "INVALID_OPERATION",
    "INSUFFICIENT_BUFFER_SIZE",
    "NO_MORE_DATA",
    "DECODING_ERROR",
    "INSTRUCTION_TOO_LONG",
    "BAD_REGISTER",
    "ILLEGAL_LOCK",
    "ILLEGAL_LEGACY_PFX",
    "ILLEGAL_REX",
    "INVALID_MAP",
    "MALFORMED_EVEX",
    "MALFORMED_MVEX",
    "INVALID_MASK",
    "IMPOSSIBLE_INSTRUCTION",
    "INSUFFICIENT_BUFFER_SIZE"
};

flagNames =
{
    [0] = "CF",
    "PF",
    "AF",
    "ZF",
    "SF",
    "TF",
    "IF",
    "DF",
    "OF",
    "IOPL",
    "NT",
    "RF",
    "VM",
    "AC",
    "VIF",
    "VIP",
    "ID",
    "C0",
    "C1",
    "C2",
    "C3"
};

 flagActions =
{
    [0] = "   ",
    "T  ",
    "T_M",
    "M  ",
    "0  ",
    "1  ",
    "U  "
};

broadcastStrings =
{
    [0] = "NONE",
    "1_TO_2",
    "1_TO_4",
    "1_TO_8",
    "1_TO_16",
    "1_TO_32",
    "1_TO_64",
    "2_TO_4",
    "2_TO_8",
    "2_TO_16",
    "4_TO_8",
    "4_TO_16",
    "8_TO_16"
};

maskModeStrings =
{
    [0] = "NONE",
    "MERGE",
    "ZERO"
};

roundingModeStrings =
{
    [0] = "DEFAULT",
    "RN",
    "RD",
    "RU",
    "RZ"
};

swizzleModeStrings =
{
    [0] = "NONE",
    "DCBA",
    "CDAB",
    "BADC",
    "DACB",
    "AAAA",
    "BBBB",
    "CCCC",
    "DDDD"
};

conversionModeStrings =
{
    [0] = "NONE",
    "FLOAT16",
    "SINT8",
    "UINT8",
    "SINT16",
    "UINT16"
};

opcodeMapStrings =
{
    [0] = "DEFAULT",
    "0F",
    "0F38",
    "0F3A",
    "0F0F",
    "XOP8",
    "XOP9",
    "XOPA"
};

instructionEncodingStrings =
{
    [0] = "",
    "DEFAULT",
    "3DNOW",
    "XOP",
    "VEX",
    "EVEX",
    "MVEX"
};

exceptionClassStrings =
{
    [0] = "NONE",
    "SSE1",
    "SSE2",
    "SSE3",
    "SSE4",
    "SSE5",
    "SSE7",
    "AVX1",
    "AVX2",
    "AVX3",
    "AVX4",
    "AVX5",
    "AVX6",
    "AVX7",
    "AVX8",
    "AVX11",
    "AVX12",
    "E1",
    "E1NF",
    "E2",
    "E2NF",
    "E3",
    "E3NF",
    "E4",
    "E4NF",
    "E5",
    "E5NF",
    "E6",
    "E6NF",
    "E7NM",
    "E7NM128",
    "E9NF",
    "E10",
    "E10NF",
    "E11",
    "E11NF",
    "E12",
    "E12NP",
    "K20",
    "K21"
};

}
