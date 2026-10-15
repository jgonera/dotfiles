// The layout, shared by all keyboards.
//
// Layers are written in the shape of the ErgoDox EZ (the order of
// LAYOUT_ergodox_pretty), the biggest of the supported keyboards. wrappers.h
// maps them onto the Moonlander and Voyager, skipping the keys they don't
// have. See ../../README.md for which keys end up where.
//
// To add a layer: give it a number, define LAYER_<NAME> below and add it to
// KEYMAPS. (Layer numbers are #defines rather than an enum so that the image
// generator sees numbers in LT(), MO() etc.)

#pragma once

#define BASE 0
#define SYMB 1

// clang-format off

#define LAYER_BASE \
    KC_GRV,           KC_1,             KC_2,             KC_3,             KC_4,             KC_5,             XXXXXXX,              XXXXXXX,          KC_6,             KC_7,             KC_8,             KC_9,             KC_0,             KC_MINS,        \
    KC_TAB,           KC_Q,             KC_W,             KC_E,             KC_R,             KC_T,             XXXXXXX,              XXXXXXX,          KC_Y,             KC_U,             KC_I,             KC_O,             KC_P,             KC_BSLS,        \
    KC_CAPS,          KC_A,             KC_S,             KC_D,             KC_F,             KC_G,                                                     KC_H,             KC_J,             KC_K,             KC_L,             KC_SCLN,          KC_QUOT,        \
    LSFT_T(KC_ESC),   LSFT_T(KC_Z),     LCTL_T(KC_X),     KC_C,             KC_V,             KC_B,             XXXXXXX,              XXXXXXX,          KC_N,             KC_M,             KC_COMM,          RCTL_T(KC_DOT),   RSFT_T(KC_SLSH),  RSFT_T(KC_EQL), \
    XXXXXXX,          KC_LCTL,          XXXXXXX,          LALT_T(KC_ESC),   LGUI_T(KC_ESC),                                                                               KC_RALT,          KC_RGUI,          KC_LBRC,          RCTL_T(KC_RBRC),  XXXXXXX,        \
                                                                                              KC_MPRV,          KC_MNXT,              KC_VOLD,          KC_VOLU,                                                                                                  \
                                                                                                                KC_MPLY,              KC_MUTE,                                                                                                                    \
                                                                            LT(SYMB, KC_SPC), KC_BSPC,          KC_DEL,               XXXXXXX,          KC_ENT,           LT(SYMB, KC_SPC)

#define LAYER_SYMB \
    _______,          KC_F1,            KC_F2,            KC_F3,            KC_F4,            KC_F5,            KC_F11,               KC_F12,           KC_F6,            KC_F7,            KC_F8,            KC_F9,            KC_F10,           _______, \
    _______,          _______,          _______,          _______,          _______,          _______,          _______,              _______,          _______,          _______,          _______,          _______,          _______,          _______, \
    KC_SPC,           KC_LCBR,          KC_RCBR,          KC_LPRN,          KC_RPRN,          KC_UNDS,                                                  KC_LEFT,          KC_DOWN,          KC_UP,            KC_RGHT,          KC_UNDS,          _______, \
    _______,          LSFT_T(KC_LBRC),  LCTL_T(KC_RBRC),  KC_LABK,          KC_RABK,          KC_MINS,          _______,              _______,          KC_HOME,          KC_PGDN,          KC_PGUP,          RCTL_T(KC_END),   RSFT_T(KC_MINS),  _______, \
    _______,          _______,          _______,          _______,          _______,                                                                                      _______,          _______,          _______,          _______,          _______, \
                                                                                              _______,          _______,              _______,          _______,                                                                                           \
                                                                                                                _______,              _______,                                                                                                             \
                                                                            _______,          _______,          _______,              _______,          _______,          _______

// clang-format on

#define KEYMAPS(layout)            \
    [BASE] = layout(LAYER_BASE), \
    [SYMB] = layout(LAYER_SYMB)
