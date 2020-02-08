#define SW_BASE 0x2020
#define LEDR_BASE 0x2030
#define LDA_BASE 0x2000

volatile int *SW = (int *) SW_BASE;
volatile int *LDA = (int *) LDA_BASE;

int main () {
    int points[12][2];

    points[0][0] = 100;
    points[0][1] = 200;

    points[1][0] = 200;
    points[1][1] = 0;

    points[2][0] = 150;
    points[2][1] = 100;

    points[3][0] = 100;
    points[3][1] = 0;

    points[4][0] = 225;
    points[4][1] = 150;

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
    int color = 0;

    volatile int test_mode = *SW & 0b1;
    volatile int fix_poll_mode = *SW & 0b10;

    for (int i=0; i<12; ++i) {
        // Write x1, y1 and color
        x = points[i][0];
        y = points[i][1];
        color = 1 + (color % 7);
        *(LDA + 4) = (y << 9) + x;
        *(LDA + 5) = color;

        // Draw the line
        *(LDA + 2) = 1;

        if (i == 4 && test_mode != 0) {
            // Switch to poll mode.
            // Should skip lines in poll mode as we
            // are not polling
            *(LDA) = 1;
            if (fix_poll_mode != 0) {
                // Does not skip lines because we wait for status
                volatile int status;
                while ((status = (*(LDA + 1) & 1)) != 0); // Loop till status is 0
            }
        }

        // Update starting point
        *(LDA + 3) = (y << 9) + x;

        // Update color
        color++;
    }

    while (1);

    return 0;
}