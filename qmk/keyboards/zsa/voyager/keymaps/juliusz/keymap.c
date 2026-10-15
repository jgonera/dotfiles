#include QMK_KEYBOARD_H
#include "layout.h"
#include "wrappers.h"

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
    KEYMAPS(LAYOUT_voyager_from_ergodox),
};
