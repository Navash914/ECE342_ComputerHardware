#include "utils.h"

int main () {

    // Clear screen
    clear_screen();
    set_start_point(0, 0);

    int points[12][2];

    points[0][0] = 100;
    points[0][1] = 200;

    points[1][0] = 200;
    points[1][1] = 0;

    points[2][0] = 150;
    points[2][1] = 100;

    points[3][0] = 100;
    points[3][1] = 0;

    points[4][0] = 200;
    points[4][1] = 125;

    points[5][0] = 300;
    points[5][1] = 100;

    points[6][0] = 150;
    points[6][1] = 200;

    points[7][0] = 50;
    points[7][1] = 150;

    points[8][0] = 100;
    points[8][1] = 150;

    points[9][0] = 100;
    points[9][1] = 200;

    points[10][0] = 50;
    points[10][1] = 200;

    points[11][0] = 50;
    points[11][1] = 150;

    int x, y;
    int color = 0, c = 0;

    for (int i=0; i<12; ++i) {
        // Write x1, y1 and color
        x = points[i][0];
        y = points[i][1];
        color = 1 + (c % 7);
        set_color(color);
        draw_line_to(x, y);

        // Update starting point
        set_start_point(x, y);

        // Update color
        c++;
    }

    while (1);

    return 0;
}