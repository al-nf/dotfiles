RGB_MATRIX_EFFECT(PETRA_REACTIVE)

#ifdef RGB_MATRIX_CUSTOM_EFFECT_IMPLS
#include "petra.h"

static bool PETRA_REACTIVE(effect_params_t *params) {
    RGB_MATRIX_USE_LIMITS(led_min, led_max);
    petra_render(led_min, led_max);
    return rgb_matrix_check_finished_leds(led_max);
}
#endif
