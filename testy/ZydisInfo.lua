
--[[
  @file
  @brief   Disassembles a given hex-buffer and prints detailed information about the decoded
           instruction, the operands and additional attributes.
--]]

package.path = "../?.lua;"..package.path

local ffi = require("ffi")
local bit = require("bit")

local namespace = require("lj2zydis.namespace")()

local zydis = require("lj2zydis.zydis")
local ZydisEnum = require("ZydisEnum")

enum.inject(zydis, namespace)
enum.inject(ZydisEnums, namespace)



--[[
/* ============================================================================================== */
/* Helper functions                                                                               */
/* ============================================================================================== */
--]]

local function ZydisFormatStatus(status)
    return StatusStrings[status];
end

--[[
 Print functions
--]]
local function fputs(str, outplace)
    io.write(str);
    return true;
end

local function printf(fmt, ...)
    io.write(string.format(fmt,...))
    return true;
end

local function printOperands(instruction)

    fputs("== [ OPERANDS ] =====================================================", stdout);
    fputs("=======================================\n", stdout);
    fputs("##       TYPE  VISIBILITY  ACTION      ENCODING   SIZE  NELEM  ELEMSZ", stdout);
    fputs("  ELEMTYPE                        VALUE\n", stdout);
    fputs("--  ---------  ----------  ------  ------------   ----  -----  ------", stdout);
    fputs("  --------  ---------------------------\n", stdout);
    local immId = 0;
    local i = 0;
    while (i < instruction.operandCount) do
    

        printf("%2d  %9s  %10s  %6s  %12s  %5d   %4d  %6d  %8s",
            i,
            operandTypes[instruction.operands[i].type],
            operandVisibilities[instruction.operands[i].visibility],
            operandActions[instruction.operands[i].action],
            operandEncodings[instruction.operands[i].encoding],
            instruction.operands[i].size,
            instruction.operands[i].elementCount,
            instruction.operands[i].elementSize,
            elementTypes[instruction.operands[i].elementType]);
--[[
        local kind = instruction.operands[i].type
        if kind == ZYDIS_OPERAND_TYPE_REGISTER then
            printf("  %27s", ZydisRegisterGetString(instruction.operands[i].reg.value));
        elseif kind == ZYDIS_OPERAND_TYPE_MEMORY then
            printf("  TYPE  =%20s\n", memopTypes[instruction.operands[i].mem.type]);
            printf("  %84s =%20s\n",
                "SEG  ", ZydisRegisterGetString(instruction.operands[i].mem.segment));
            printf("  %84s =%20s\n",
                "BASE ", ZydisRegisterGetString(instruction.operands[i].mem.base));
            printf("  %84s =%20s\n",
                "INDEX", ZydisRegisterGetString(instruction.operands[i].mem.index));
            printf("  %84s =%20d\n", "SCALE", instruction.operands[i].mem.scale);
            printf("  %84s =  0x%016"PRIX64,
                "DISP ", instruction.operands[i].mem.disp.value);

        elseif kind == ZYDIS_OPERAND_TYPE_POINTER then
            -- do nothing break;
        elseif kind == ZYDIS_OPERAND_TYPE_IMMEDIATE then
            if (instruction.operands[i].imm.isSigned ~= 0) then
            
                printf("  (%s %s %2d) 0x%016",
                    instruction.operands[i].imm.isSigned ? "S" : "U",
                    instruction.operands[i].imm.isRelative ? "R" : "_",
                    instruction.raw.imm[immId].size,
                    instruction.operands[i].imm.value.s);
            else
                printf("  SIGN  =%20s\n", instruction.operands[i].imm.isSigned ? "Y" : "N");
                printf("  %84s =%20s\n",
                    "REL  ", instruction.operands[i].imm.isRelative ? "Y" : "N");
                printf("  %84s =                  %2d\n",
                    "SIZE ", instruction.raw.imm[immId].size);
                printf("  %84s =  0x%016",
                    "VALUE", instruction.operands[i].imm.value.u);
            end
            immId = immId + 1;

        else
            -- ZYDIS_UNREACHABLE;
        end
--]]
        puts("");
        i = i+1;
    end
    
    fputs("--  ---------  ----------  ------  ------------   ----  -----  ------", stdout);
    fputs("  --------  ---------------------------\n", stdout);
end


local function printFlags(instruction)



    fputs("== [    FLAGS ] =====================================================", stdout);
    fputs("=======================================\n", stdout);
    printf("    ACTIONS: ");
    local c = 0;


    for (ZydisCPUFlag i = 0; i < ZYDIS_ARRAY_SIZE(instruction.accessedFlags); ++i)
    {
        if (instruction.accessedFlags[i].action != ZYDIS_CPUFLAG_ACTION_NONE)
        {
            if (c && (c % 8 == 0))
            {
                printf("\n             ");
            }
            ++c;
            printf("[%-4s: %s] ", flagNames[i], flagActions[instruction.accessedFlags[i].action]);
        }
    }
    if c > 0 then
        puts("")
    else
        puts("none")
    end


    ZydisCPUFlagMask flags, temp;
    ZydisGetAccessedFlagsByAction(instruction, ZYDIS_CPUFLAG_ACTION_TESTED, &flags);
    printf("       READ: 0x%08" PRIX32 "\n", flags);
    ZydisGetAccessedFlagsByAction(instruction, ZYDIS_CPUFLAG_ACTION_MODIFIED, &flags);
    ZydisGetAccessedFlagsByAction(instruction, ZYDIS_CPUFLAG_ACTION_SET_0, &temp);
    flags |= temp;
    ZydisGetAccessedFlagsByAction(instruction, ZYDIS_CPUFLAG_ACTION_SET_1, &temp);
    flags |= temp;
    printf("    WRITTEN: 0x%08" PRIX32 "\n", flags);
    ZydisGetAccessedFlagsByAction(instruction, ZYDIS_CPUFLAG_ACTION_UNDEFINED, &flags);
    printf("  UNDEFINED: 0x%08" PRIX32 "\n", flags);
end

--[=[
local function printAVXInfo(instruction)



    fputs("== [      AVX ] =====================================================", stdout);
    fputs("=======================================\n", stdout);

    printf("  VECTORLEN: %03d\n", instruction.avx.vectorLength);
    printf("  BROADCAST: %s%s", broadcastStrings[instruction.avx.broadcast.mode],
        instruction.avx.broadcast.isStatic ? " (static)" : "");

    switch (instruction.encoding)
    {
    case ZYDIS_INSTRUCTION_ENCODING_EVEX:
        printf("\n   ROUNDING: %s", roundingModeStrings[instruction.avx.rounding.mode]);
        printf("\n        SAE: %s", instruction.avx.hasSAE ? "Y" : "N");
        printf("\n       MASK: %s [%5s]%s", ZydisRegisterGetString(instruction.avx.mask.reg),
            maskModeStrings[instruction.avx.mask.mode],
            instruction.avx.mask.isControlMask ? " (control-mask)" : "");
        break;
    case ZYDIS_INSTRUCTION_ENCODING_MVEX:
        printf("\n   ROUNDING: %s", roundingModeStrings[instruction.avx.rounding.mode]);
        printf("\n        SAE: %s", instruction.avx.hasSAE ? "Y" : "N");
        printf("\n       MASK: %s [MERGE]", ZydisRegisterGetString(instruction.avx.mask.reg));
        printf("\n         EH: %s", instruction.avx.hasEvictionHint ? "Y" : "N");
        printf("\n    SWIZZLE: %s", swizzleModeStrings[instruction.avx.swizzle.mode]);
        printf("\n    CONVERT: %s", conversionModeStrings[instruction.avx.conversion.mode]);
        break;
    default:
        break;
    }
    puts("");
}
--]=]

local function printInstruction(instruction)


    local attributeMap =
    {
        [0] = { ZYDIS_ATTRIB_HAS_MODRM,          "HAS_MODRM"                },
        { ZYDIS_ATTRIB_HAS_SIB,                  "HAS_SIB"                  },
        { ZYDIS_ATTRIB_HAS_REX,                  "HAS_REX"                  },
        { ZYDIS_ATTRIB_HAS_XOP,                  "HAS_XOP"                  },
        { ZYDIS_ATTRIB_HAS_VEX,                  "HAS_VEX"                  },
        { ZYDIS_ATTRIB_HAS_EVEX,                 "HAS_EVEX"                 },
        { ZYDIS_ATTRIB_HAS_MVEX,                 "HAS_MVEX"                 },
        { ZYDIS_ATTRIB_IS_RELATIVE,              "IS_RELATIVE"              },
        { ZYDIS_ATTRIB_IS_PRIVILEGED,            "IS_PRIVILEGED"            },
        { ZYDIS_ATTRIB_IS_FAR_BRANCH,            "IS_FAR_BRANCH"            },
        { ZYDIS_ATTRIB_ACCEPTS_LOCK,             "ACCEPTS_LOCK"             },
        { ZYDIS_ATTRIB_ACCEPTS_REP,              "ACCEPTS_REP"              },
        { ZYDIS_ATTRIB_ACCEPTS_REPE,             "ACCEPTS_REPE"             },
        { ZYDIS_ATTRIB_ACCEPTS_REPZ,             "ACCEPTS_REPZ"             },
        { ZYDIS_ATTRIB_ACCEPTS_REPNE,            "ACCEPTS_REPNE"            },
        { ZYDIS_ATTRIB_ACCEPTS_REPNZ,            "ACCEPTS_REPNZ"            },
        { ZYDIS_ATTRIB_ACCEPTS_BOUND,            "ACCEPTS_BOUND"            },
        { ZYDIS_ATTRIB_ACCEPTS_XACQUIRE,         "ACCEPTS_XACQUIRE"         },
        { ZYDIS_ATTRIB_ACCEPTS_XRELEASE,         "ACCEPTS_XRELEASE"         },
        { ZYDIS_ATTRIB_ACCEPTS_HLE_WITHOUT_LOCK, "ACCEPTS_HLE_WITHOUT_LOCK" },
        { ZYDIS_ATTRIB_ACCEPTS_BRANCH_HINTS,     "ACCEPTS_BRANCH_HINTS"     },
        { ZYDIS_ATTRIB_ACCEPTS_SEGMENT,          "ACCEPTS_SEGMENT"          },
        { ZYDIS_ATTRIB_HAS_LOCK,                 "HAS_LOCK"                 },
        { ZYDIS_ATTRIB_HAS_REP,                  "HAS_REP"                  },
        { ZYDIS_ATTRIB_HAS_REPE,                 "HAS_REPE"                 },
        { ZYDIS_ATTRIB_HAS_REPZ,                 "HAS_REPZ"                 },
        { ZYDIS_ATTRIB_HAS_REPNE,                "HAS_REPNE"                },
        { ZYDIS_ATTRIB_HAS_REPNZ,                "HAS_REPNZ"                },
        { ZYDIS_ATTRIB_HAS_BOUND,                "HAS_BOUND"                },
        { ZYDIS_ATTRIB_HAS_XACQUIRE,             "HAS_XACQUIRE"             },
        { ZYDIS_ATTRIB_HAS_XRELEASE,             "HAS_XRELEASE"             },
        { ZYDIS_ATTRIB_HAS_BRANCH_NOT_TAKEN,     "HAS_BRANCH_NOT_TAKEN"     },
        { ZYDIS_ATTRIB_HAS_BRANCH_TAKEN,         "HAS_BRANCH_TAKEN"         },
        { ZYDIS_ATTRIB_HAS_SEGMENT,              "HAS_SEGMENT"              },
        { ZYDIS_ATTRIB_HAS_SEGMENT_CS,           "HAS_SEGMENT_CS"           },
        { ZYDIS_ATTRIB_HAS_SEGMENT_SS,           "HAS_SEGMENT_SS"           },
        { ZYDIS_ATTRIB_HAS_SEGMENT_DS,           "HAS_SEGMENT_DS"           },
        { ZYDIS_ATTRIB_HAS_SEGMENT_ES,           "HAS_SEGMENT_ES"           },
        { ZYDIS_ATTRIB_HAS_SEGMENT_FS,           "HAS_SEGMENT_FS"           },
        { ZYDIS_ATTRIB_HAS_SEGMENT_GS,           "HAS_SEGMENT_GS"           },
        { ZYDIS_ATTRIB_HAS_OPERANDSIZE,          "HAS_OPERANDSIZE"          },
        { ZYDIS_ATTRIB_HAS_ADDRESSSIZE,          "HAS_ADDRESSSIZE"          }
    };

    fputs("== [    BASIC ] =====================================================", stdout);
    fputs("=======================================\n", stdout);
    printf("   MNEMONIC: %s [ENC: %s, MAP: %s, OPC: %02X]\n",
        ZydisMnemonicGetString(instruction.mnemonic),
        instructionEncodingStrings[instruction.encoding],
        opcodeMapStrings[instruction.opcodeMap],
        instruction.opcode);
    printf("     LENGTH: %2d\n", instruction.length);
    printf("        SSZ: %2d\n", instruction.stackWidth);
    printf("       EOSZ: %2d\n", instruction.operandWidth);
    printf("       EASZ: %2d\n", instruction.addressWidth);
    printf("   CATEGORY: %s\n", ZydisCategoryGetString(instruction.meta.category));
    printf("    ISA-SET: %s\n", ZydisISASetGetString(instruction.meta.isaSet));
    printf("    ISA-EXT: %s\n", ZydisISAExtGetString(instruction.meta.isaExt));
    printf(" EXCEPTIONS: %s\n", exceptionClassStrings[instruction.meta.exceptionClass]);

    if (instruction.attributes)
    {
        fputs (" ATTRIBUTES: ", stdout);
        for (size_t i = 0; i < ZYDIS_ARRAY_SIZE(attributeMap); ++i)
        {
            if (instruction.attributes & attributeMap[i].attrMask)
            {
                printf("%s ", attributeMap[i].str);
            }
        }
        fputs("\n", stdout);
    }

    if (instruction.operandCount > 0)
    {
        puts("");
        printOperands(instruction);
    }

    if (ZydisRegisterGetClass(
        instruction.operands[instruction.operandCount - 1].reg.value) == ZYDIS_REGCLASS_FLAGS)
    {
        puts("");
        printFlags(instruction);
    }

    if ((instruction.encoding == ZYDIS_INSTRUCTION_ENCODING_XOP) ||
        (instruction.encoding == ZYDIS_INSTRUCTION_ENCODING_VEX) ||
        (instruction.encoding == ZYDIS_INSTRUCTION_ENCODING_EVEX) ||
        (instruction.encoding == ZYDIS_INSTRUCTION_ENCODING_MVEX))
    {
        puts("");
        printAVXInfo(instruction);
    }

    ZydisStatus status;
    ZydisFormatter formatter;
    if (!ZYDIS_SUCCESS((status = ZydisFormatterInit(&formatter, ZYDIS_FORMATTER_STYLE_INTEL))) ||
        !ZYDIS_SUCCESS((status = ZydisFormatterSetProperty(&formatter,
            ZYDIS_FORMATTER_PROP_FORCE_MEMSEG, ZYDIS_TRUE))) ||
        !ZYDIS_SUCCESS((status = ZydisFormatterSetProperty(&formatter,
            ZYDIS_FORMATTER_PROP_FORCE_MEMSIZE, ZYDIS_TRUE))))
    {
        fputs("Failed to initialize instruction-formatter\n", stderr);
        exit(status);
    }
    char buffer[256];
    ZydisFormatterFormatInstruction(&formatter, instruction, &buffer[0], sizeof(buffer));
    fputs("\n== [   DISASM ] =====================================================", stdout);
    fputs("=======================================\n", stdout);
    printf("  %s\n", &buffer[0]);
}


--[[
/* ============================================================================================== */
/* Entry point                                                                                    */
/* ============================================================================================== */
--]]
local argv = {...}
local argc = select('#', ...)
local function main()
    print(argc, argv, argv[1])

    if (ZydisGetVersion() ~= ZYDIS_VERSION) then
    
        fputs("Invalid zydis version\n", stderr);
        return ZYDIS_STATUS_INVALID_OPERATION;
    end

    if argc < 2 then
    
        fputs("Usage: ZydisInfo -[real|16|32|64] [hexbytes]\n", stderr);
        return ZYDIS_STATUS_INVALID_PARAMETER;
    end
--[=[
    ZydisDecoder decoder;
    if (!strcmp(argv[1], "-real"))
    {
        ZydisDecoderInit(&decoder, ZYDIS_MACHINE_MODE_REAL_16, ZYDIS_ADDRESS_WIDTH_16);
    } else
    if (!strcmp(argv[1], "-16"))
    {
        ZydisDecoderInit(&decoder, ZYDIS_MACHINE_MODE_LONG_COMPAT_16, ZYDIS_ADDRESS_WIDTH_16);
    } else
    if (!strcmp(argv[1], "-32"))
    {
        ZydisDecoderInit(&decoder, ZYDIS_MACHINE_MODE_LONG_COMPAT_32, ZYDIS_ADDRESS_WIDTH_32);
    } else
    if (!strcmp(argv[1], "-64"))
    {
        ZydisDecoderInit(&decoder, ZYDIS_MACHINE_MODE_LONG_64, ZYDIS_ADDRESS_WIDTH_64);
    } else
    {
        fputs("Usage: ZydisInfo -[real|16|32|64] [hexbytes]\n", stderr);
        return ZYDIS_STATUS_INVALID_PARAMETER;
    }

    uint8_t data[ZYDIS_MAX_INSTRUCTION_LENGTH];
    uint8_t length = 0;
    for (uint8_t i = 0; i < argc - 2; ++i)
    {
        if (length == ZYDIS_MAX_INSTRUCTION_LENGTH)
        {
            fprintf(stderr, "Maximum number of %d bytes exceeded", ZYDIS_MAX_INSTRUCTION_LENGTH);
            return ZYDIS_STATUS_INVALID_PARAMETER;
        }
        const size_t len = strlen(argv[i + 2]);
        if (len % 2)
        {
            fputs("Even number of hex nibbles expected", stderr);
            return ZYDIS_STATUS_INVALID_PARAMETER;
        }
        for (uint8_t j = 0; j < len / 2; ++j)
        {
            unsigned value;
            if (!sscanf(&argv[i + 2][j * 2], "%02x", &value))
            {
                fputs("Invalid hex value", stderr);
                return ZYDIS_STATUS_INVALID_PARAMETER;
            }
            data[length] = (uint8_t)value;
            ++length;
        }
    }

    ZydisDecodedInstruction instruction;
    const ZydisStatus status = ZydisDecoderDecodeBuffer(&decoder, &data, length, 0, &instruction);
    if (!ZYDIS_SUCCESS(status))
    {
        if (status >= ZYDIS_STATUS_USER)
        {
            fprintf(stderr,
                "Could not decode instruction: User defined status code 0x%" PRIx32, status);
        } else
        {
            fprintf(stderr, "Could not decode instruction: %s", ZydisFormatStatus(status));
        }
        return status;
    }

    printInstruction(instruction);
--]=]
    return true;
end

main()