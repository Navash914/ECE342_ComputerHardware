#define SW_BASE 0x2020
#define LEDR_BASE 0x2030
#define LDA_BASE 0x2000

#define X_MIN 0
#define X_MAX 335
#define Y_MIN 0
#define Y_MAX 209
#define Y_BOUND 210

#define MODE_SW 0b1000000000
#define MOVE_UP_SW 0b0100000000
#define COLOR_SW 0b111

volatile int *SW = (int *) SW_BASE;
volatile int *LDA = (int *) LDA_BASE;

int main () {
    int prev_y = Y_MAX;
    int y = 0;  // Start at top of screen

    while (1) {
        // Draw line at current position
        *(LDA + 3) = (y << 9) + X_MIN;  // Set Starting Point
        *(LDA + 4) = (y << 9) + X_MAX;  // Set Ending Point
        *(LDA + 5) = *SW & COLOR_SW;    // Set color
        *(LDA + 2) = 1;                 // Initiate LDA

        if (*(LDA) & 1 == 1) {
            // Poll Mode
            // Wait for status to go to 0
            volatile int status;
            while ((status = (*(LDA + 1) & 1)) != 0);
        }

        // Erase line at previous position
        *(LDA + 3) = (prev_y << 9) + X_MIN;  // Set Starting Point
        *(LDA + 4) = (prev_y << 9) + X_MAX;  // Set Ending Point
        *(LDA + 5) = 0;                      // Set color
        *(LDA + 2) = 1;                      // Initiate LDA

        if (*(LDA) & 1 == 1) {
            // Poll Mode
            // Wait for status to go to 0
            volatile int status;
            while ((status = (*(LDA + 1) & 1)) != 0);
        }

        // Wait for frame
        for (int i=0; i<10000000; ++i);

        // Update positions
        prev_y = y;
        if (*SW & MOVE_UP_SW)
            y = (Y_BOUND + (y - 1)) % Y_BOUND;  // Moving Up
        else
            y = (y + 1) % Y_BOUND;    // Moving Down

        // Update mode
        *(LDA) = *SW & MODE_SW;

    }

    return 0;
}