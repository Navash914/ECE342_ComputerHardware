#include <math.h>

#define SW_BASE 0x2020
#define LEDR_BASE 0x2030
#define LDA_BASE 0x2000

#define CENTER_X 168
#define CENTER_Y 105
#define DTHETA 5

#define MODE_SW 0b1000000000
#define CCW_SW 0b0100000000
#define COLOR_SW 0b111

volatile int *SW = (int *) SW_BASE;
volatile int *LDA = (int *) LDA_BASE;

int main () {
    int x, y, prev_x = CENTER_X-1, prev_y = CENTER_Y;
    float theta = 0.0;

    // Set starting point. This does not change.
    *(LDA + 3) = (CENTER_Y << 9) + CENTER_X;

    while (1) {
        // Draw line at current position
        x = 20 * cos(theta) + CENTER_X;
        y = 20 * sin(theta) + CENTER_Y;
        *(LDA + 4) = (y << 9) + x;      // Set Ending Point
        *(LDA + 5) = *SW & COLOR_SW;    // Set color
        *(LDA + 2) = 1;                 // Initiate LDA

        if (*(LDA) & 1 == 1) {
            // Poll Mode
            // Wait for status to go to 0
            volatile int status;
            while ((status = (*(LDA + 1) & 1)) != 0);
        }

        // Erase line at previous position
        *(LDA + 4) = (prev_y << 9) + prev_x;  // Set Ending Point
        *(LDA + 5) = 0;                       // Set color
        *(LDA + 2) = 1;                       // Initiate LDA

        if (*(LDA) & 1 == 1) {
            // Poll Mode
            // Wait for status to go to 0
            volatile int status;
            while ((status = (*(LDA + 1) & 1)) != 0);
        }

        // Wait for frame
        for (int i=0; i<10000000; ++i);

        // Update positions
        prev_x = x;
        prev_y = y;
        if (*SW & CCW_SW) {
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
        *(LDA) = *SW & MODE_SW;

    }

    return 0;
}