#include "../default/keymap.c"
#include "raw_hid.h"
#include "petra.h"
#include "petra_defaults.h"
#include <string.h>

static uint8_t target_colors[6] = PETRA_DEFAULT_COLORS;
static uint8_t previous_colors[6] = PETRA_DEFAULT_COLORS;
static uint16_t fade_ms = PETRA_DEFAULT_FADE_MS;
static uint8_t radius = PETRA_DEFAULT_RADIUS;
static uint16_t transition_ms;
static uint32_t transition_started;

static void current_colors(uint8_t colors[6]) {
    uint32_t elapsed = timer_elapsed32(transition_started);
    if (!transition_ms || elapsed >= transition_ms) {
        memcpy(colors, target_colors, 6);
        transition_ms = 0;
        return;
    }
    for (uint8_t channel = 0; channel < 6; channel++) {
        colors[channel] = previous_colors[channel] + ((int32_t)target_colors[channel] - previous_colors[channel]) * (int32_t)elapsed / transition_ms;
    }
}

void keyboard_post_init_user(void) {
    rgb_matrix_mode_noeeprom(RGB_MATRIX_CUSTOM_PETRA_REACTIVE);
    rgb_matrix_sethsv_noeeprom(0, 0, 255);
}

void raw_hid_receive(uint8_t *data, uint8_t length) {
    if (length != 32 || memcmp(data, "PTR1", 4) != 0) {
        return;
    }
    uint8_t command = data[4];
    uint8_t status = 0;
    if (command == 1) {
        uint16_t requested_fade = data[11] | ((uint16_t)data[12] << 8);
        uint16_t requested_transition = data[13] | ((uint16_t)data[14] << 8);
        if (requested_fade < 100 || requested_fade > 2000 || requested_transition > 2000 || data[15] < 8 || data[15] > 64) {
            status = 1;
        } else {
            current_colors(previous_colors);
            memcpy(target_colors, &data[5], 6);
            fade_ms = requested_fade;
            transition_ms = requested_transition;
            transition_started = timer_read32();
            radius = data[15];
            rgb_matrix_mode_noeeprom(RGB_MATRIX_CUSTOM_PETRA_REACTIVE);
        }
    } else if (command != 2) {
        status = 1;
    }
    memset(data, 0, length);
    memcpy(data, "PTR1", 4);
    data[4] = command | 0x80;
    memcpy(&data[5], target_colors, 6);
    data[11] = fade_ms & 0xff;
    data[12] = fade_ms >> 8;
    data[13] = transition_ms & 0xff;
    data[14] = transition_ms >> 8;
    data[15] = radius;
    data[31] = status;
    raw_hid_send(data, length);
}

void petra_render(uint8_t led_min, uint8_t led_max) {
    uint8_t colors[6];
    current_colors(colors);
    uint32_t radius_squared = (uint32_t)radius * radius;
    uint8_t brightness = rgb_matrix_get_val();
    for (uint8_t led = led_min; led < led_max; led++) {
        uint8_t weight = 0;
        for (uint8_t hit = 0; hit < g_last_hit_tracker.count; hit++) {
            uint16_t age = g_last_hit_tracker.tick[hit];
            if (age >= fade_ms) {
                continue;
            }
            int32_t distance_x = (int32_t)g_led_config.point[led].x - g_last_hit_tracker.x[hit];
            int32_t distance_y = (int32_t)g_led_config.point[led].y - g_last_hit_tracker.y[hit];
            uint32_t distance_squared = distance_x * distance_x + distance_y * distance_y;
            if (distance_squared >= radius_squared) {
                continue;
            }
            uint32_t spatial = (radius_squared - distance_squared) * 255 / radius_squared;
            spatial = spatial * spatial / 255;
            uint32_t remaining = fade_ms - age;
            uint8_t influence = spatial * remaining * remaining / ((uint32_t)fade_ms * fade_ms);
            if (influence > weight) {
                weight = influence;
            }
        }
        uint8_t blended[3];
        for (uint8_t channel = 0; channel < 3; channel++) {
            int32_t value = colors[channel] + ((int32_t)colors[channel + 3] - colors[channel]) * weight / 255;
            blended[channel] = value * brightness / 255;
        }
        rgb_matrix_set_color(led, blended[0], blended[1], blended[2]);
    }
}
