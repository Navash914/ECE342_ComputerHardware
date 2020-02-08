#include <math.h>
#include "utils.h"

#define CENTER_X 168
#define CENTER_Y 105
#define DTHETA 1

#define MODE_SW 4
#define CCW_SW 3
#define COLOR_MASK 0b111

int main () {

    clear_screen();

    int x, y, prev_x = CENTER_X-10, prev_y = CENTER_Y;
    float theta = 0.0;

    // Set starting point. This does not change.
    set_start_point(CENTER_X, CENTER_Y);

    while (1) {
        // Draw line at current position
        x = 1 * cos(theta * (3.141592 / 180.0)) + CENTER_X;
        y = 1 * sin(theta * (3.141592 / 180.0)) + CENTER_Y;
        set_color(get_all_switches() & COLOR_MASK);
        draw_line_to(x, y);

        // Erase line at previous position
        set_color(0);
        draw_line_to(prev_x, prev_y);

        // Update positions
        prev_x = x;
        prev_y = y;
        if (get_switch(CCW_SW)) {
            // Move CCW
            theta -= DTHETA;
            if (theta < 0)
                theta += 360;
        } else {
            // Move CW
            theta += DTHETA;
            if (theta >= 360)
                theta -= 360;
        }

        // Update mode
        set_mode(get_switch(MODE_SW));

        // Wait for frame
        DELAY
    }

    return 0;
}