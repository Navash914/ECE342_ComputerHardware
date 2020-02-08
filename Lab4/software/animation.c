#include "utils.h"

#define MODE_SW 4
#define MOVE_UP_SW 3
#define COLOR_MASK 0b111

int main () {
    clear_screen();
    int prev_y = Y_MAX;
    int y = 0;  // Start at top of screen

    while (1) {
        // Draw line at current position
        set_color(get_all_switches() & COLOR_MASK);
        draw_line_from_to(X_MIN, y, X_MAX, y);

        // Erase line at previous position
        set_color(0);
        draw_line_from_to(X_MIN, prev_y, X_MAX, prev_y);

        // Update positions
        prev_y = y;
        if (get_switch(MOVE_UP_SW))
            y = (Y_BOUND + (y - 1)) % Y_BOUND;  // Moving Up
        else
            y = (y + 1) % Y_BOUND;    // Moving Down

        // Update mode
        set_mode(get_switch(MODE_SW));

        // Wait for frame
        DELAY
    }

    return 0;
}