local ffi = require("ffi")

require("lj2zydis.ffi.CommonTypes")

ffi.cdef[[
typedef ZydisU8 ZydisISASet;

enum ZydisISASets
{
    ZYDIS_ISA_SET_INVALID,
    ZYDIS_ISA_SET_ADOX_ADCX,
    ZYDIS_ISA_SET_AES,
    ZYDIS_ISA_SET_AMD3DNOW,
    ZYDIS_ISA_SET_AVX,
    ZYDIS_ISA_SET_AVX2,
    ZYDIS_ISA_SET_AVX2GATHER,
    ZYDIS_ISA_SET_AVX512EVEX,
    ZYDIS_ISA_SET_AVX512VEX,
    ZYDIS_ISA_SET_AVXAES,
    ZYDIS_ISA_SET_BASE,
    ZYDIS_ISA_SET_BMI1,
    ZYDIS_ISA_SET_BMI2,
    ZYDIS_ISA_SET_CET,
    ZYDIS_ISA_SET_CLFLUSHOPT,
    ZYDIS_ISA_SET_CLFSH,
    ZYDIS_ISA_SET_CLWB,
    ZYDIS_ISA_SET_CLZERO,
    ZYDIS_ISA_SET_F16C,
    ZYDIS_ISA_SET_FMA,
    ZYDIS_ISA_SET_FMA4,
    ZYDIS_ISA_SET_GFNI,
    ZYDIS_ISA_SET_INVPCID,
    ZYDIS_ISA_SET_KNC,
    ZYDIS_ISA_SET_KNCE,
    ZYDIS_ISA_SET_KNCV,
    ZYDIS_ISA_SET_LONGMODE,
    ZYDIS_ISA_SET_LZCNT,
    ZYDIS_ISA_SET_MMX,
    ZYDIS_ISA_SET_MONITOR,
    ZYDIS_ISA_SET_MONITORX,
    ZYDIS_ISA_SET_MOVBE,
    ZYDIS_ISA_SET_MPX,
    ZYDIS_ISA_SET_PAUSE,
    ZYDIS_ISA_SET_PCLMULQDQ,
    ZYDIS_ISA_SET_PCONFIG,
    ZYDIS_ISA_SET_PKU,
    ZYDIS_ISA_SET_PREFETCHWT1,
    ZYDIS_ISA_SET_PT,
    ZYDIS_ISA_SET_RDPID,
    ZYDIS_ISA_SET_RDRAND,
    ZYDIS_ISA_SET_RDSEED,
    ZYDIS_ISA_SET_RDTSCP,
    ZYDIS_ISA_SET_RDWRFSGS,
    ZYDIS_ISA_SET_RTM,
    ZYDIS_ISA_SET_SGX,
    ZYDIS_ISA_SET_SGX_ENCLV,
    ZYDIS_ISA_SET_SHA,
    ZYDIS_ISA_SET_SMAP,
    ZYDIS_ISA_SET_SMX,
    ZYDIS_ISA_SET_SSE,
    ZYDIS_ISA_SET_SSE2,
    ZYDIS_ISA_SET_SSE3,
    ZYDIS_ISA_SET_SSE4,
    ZYDIS_ISA_SET_SSE4A,
    ZYDIS_ISA_SET_SSSE3,
    ZYDIS_ISA_SET_SVM,
    ZYDIS_ISA_SET_TBM,
    ZYDIS_ISA_SET_VAES,
    ZYDIS_ISA_SET_VMFUNC,
    ZYDIS_ISA_SET_VPCLMULQDQ,
    ZYDIS_ISA_SET_VTX,
    ZYDIS_ISA_SET_X87,
    ZYDIS_ISA_SET_XOP,
    ZYDIS_ISA_SET_XSAVE,
    ZYDIS_ISA_SET_XSAVEC,
    ZYDIS_ISA_SET_XSAVEOPT,
    ZYDIS_ISA_SET_XSAVES,

    /**
     * @brief   Maximum value of this enum.
     */
    ZYDIS_ISA_SET_MAX_VALUE = ZYDIS_ISA_SET_XSAVES,
    /**
     * @brief   Minimum amount of bits required to store a value of this enum.
     */
    ZYDIS_ISA_SET_MIN_BITS  = 0x0007
};
]]