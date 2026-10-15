// Maps layers defined in the ErgoDox EZ shape (see layout.h) onto each
// keyboard's LAYOUT macro.
//
// Every wrapper takes the 76 keys of LAYOUT_ergodox_pretty, named like this:
//
//   L00 L01 L02 L03 L04 L05 L06   R00 R01 R02 R03 R04 R05 R06
//   L10 L11 L12 L13 L14 L15 L16   R10 R11 R12 R13 R14 R15 R16
//   L20 L21 L22 L23 L24 L25           R21 R22 R23 R24 R25 R26
//   L30 L31 L32 L33 L34 L35 L36   R30 R31 R32 R33 R34 R35 R36
//   L40 L41 L42 L43 L44                   R42 R43 R44 R45 R46
//                           LT0 LT1   RT0 RT1
//                               LT2   RT2
//                       LT3 LT4 LT5   RT3 RT4 RT5
//
// Column 6 on the left and column 0 on the right are the inner keys. LT3/LT4
// and RT4/RT5 are the big thumb keys.
//
// The extra level of indirection (wrapper -> wrapper_) makes the preprocessor
// expand LAYER_* into separate arguments before they are matched against the
// parameter list.

#pragma once

// clang-format off

#define LAYOUT_ergodox_pretty_wrapper(...) LAYOUT_ergodox_pretty(__VA_ARGS__)

// Moonlander: same main block, but the inner column has three 1u keys (the
// ErgoDox's lower 1.5u inner key moves up a row), the bottom row of the inner
// column doesn't exist, and the thumb cluster is 3 keys plus the red key.
// The red key gets the ErgoDox's middle thumb-cluster key. LT0, LT1, RT0 and
// RT1 are skipped.
#define LAYOUT_moonlander_from_ergodox(...) LAYOUT_moonlander_from_ergodox_(__VA_ARGS__)
#define LAYOUT_moonlander_from_ergodox_(                       \
    L00, L01, L02, L03, L04, L05, L06,  R00, R01, R02, R03, R04, R05, R06, \
    L10, L11, L12, L13, L14, L15, L16,  R10, R11, R12, R13, R14, R15, R16, \
    L20, L21, L22, L23, L24, L25,            R21, R22, R23, R24, R25, R26, \
    L30, L31, L32, L33, L34, L35, L36,  R30, R31, R32, R33, R34, R35, R36, \
    L40, L41, L42, L43, L44,                      R42, R43, R44, R45, R46, \
                              LT0, LT1,  RT0, RT1,                         \
                                   LT2,  RT2,                              \
                         LT3, LT4, LT5,  RT3, RT4, RT5                     \
) LAYOUT(                                                                  \
    L00, L01, L02, L03, L04, L05, L06,  R00, R01, R02, R03, R04, R05, R06, \
    L10, L11, L12, L13, L14, L15, L16,  R10, R11, R12, R13, R14, R15, R16, \
    L20, L21, L22, L23, L24, L25, L36,  R30, R21, R22, R23, R24, R25, R26, \
    L30, L31, L32, L33, L34, L35,            R31, R32, R33, R34, R35, R36, \
    L40, L41, L42, L43, L44,      LT2,  RT2,      R42, R43, R44, R45, R46, \
                         LT3, LT4, LT5,  RT3, RT4, RT5                     \
)

// Voyager: only the outer 6 columns of the 4 main rows and the 2 big thumb
// keys on each side. The inner column, the bottom row and the rest of the
// thumb cluster are skipped.
#define LAYOUT_voyager_from_ergodox(...) LAYOUT_voyager_from_ergodox_(__VA_ARGS__)
#define LAYOUT_voyager_from_ergodox_(                          \
    L00, L01, L02, L03, L04, L05, L06,  R00, R01, R02, R03, R04, R05, R06, \
    L10, L11, L12, L13, L14, L15, L16,  R10, R11, R12, R13, R14, R15, R16, \
    L20, L21, L22, L23, L24, L25,            R21, R22, R23, R24, R25, R26, \
    L30, L31, L32, L33, L34, L35, L36,  R30, R31, R32, R33, R34, R35, R36, \
    L40, L41, L42, L43, L44,                      R42, R43, R44, R45, R46, \
                              LT0, LT1,  RT0, RT1,                         \
                                   LT2,  RT2,                              \
                         LT3, LT4, LT5,  RT3, RT4, RT5                     \
) LAYOUT(                                                                  \
    L00, L01, L02, L03, L04, L05,            R01, R02, R03, R04, R05, R06, \
    L10, L11, L12, L13, L14, L15,            R11, R12, R13, R14, R15, R16, \
    L20, L21, L22, L23, L24, L25,            R21, R22, R23, R24, R25, R26, \
    L30, L31, L32, L33, L34, L35,            R31, R32, R33, R34, R35, R36, \
                              LT3, LT4,  RT4, RT5                          \
)

// clang-format on
