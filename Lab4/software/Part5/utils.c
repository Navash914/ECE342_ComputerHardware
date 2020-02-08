#include "utils.h"

volatile int *LEDR = (volatile int *) LEDR_BASE;
volatile int *SW = (volatile int *) SW_BASE;
volatile int *LDA = (volatile int *) LDA_BASE;


// Line Drawing Functions

void wait_if_poll_mode() {
    if (get_mode() == POLL_MODE) {
        volatile int status;
        while ((status = (*(LDA + STATUS_OFFSET) & 1)) != 0);
    }
}

int get_mode() {
    return *(LDA + MODE_OFFSET) & 1;
}

void set_mode(int mode) {
    wait_if_poll_mode();
    *(LDA + MODE_OFFSET) = mode;
}

int get_start_point(int *x, int *y) {
    int value = *(LDA + SP_OFFSET);
    if (x)
        *x = value & 0b111111111;
    if (y)
        *y = (value >> 9) & 0b11111111;
    return value;
}

void set_start_point(int x, int y) {
    wait_if_poll_mode();
    *(LDA + SP_OFFSET) = (y << 9) + x;
}

int get_end_point(int *x, int *y) {
    int value = *(LDA + EP_OFFSET);
    if (x)
        *x = value & 0b111111111;
    if (y)
        *y = (value >> 9) & 0b11111111;
    return value;
}

void set_end_point(int x, int y) {
    wait_if_poll_mode();
    *(LDA + EP_OFFSET) = (y << 9) + x;
}

int get_color() {
    return *(LDA + COLOR_OFFSET);
}

void set_color(int color) {
    wait_if_poll_mode();
    *(LDA + COLOR_OFFSET) = color;
}

void draw_line() {
    wait_if_poll_mode();
    *(LDA + GO_OFFSET) = 1;
}

void draw_line_to(int x, int y) {
    //int prev_x, prev_y;
    //int *px = prev_x, *py = prev_y;
    //get_end_point(px, py);
    set_end_point(x, y);
    draw_line();
    //set_end_point(prev_x, prev_y);
}

void draw_line_from_to(int x0, int y0, int x1, int y1) {
    //int prev_x, prev_y;
    //int *px = prev_x, *py = prev_y;
    //get_start_point(px, py);
    set_start_point(x0, y0);
    draw_line_to(x1, y1);
    //set_start_point(prev_x, prev_y);
}

void clear_screen() {
    int prev_sx, prev_sy, prev_ex, prev_ey;
    int *psx = &prev_sx, *psy = &prev_sy, *pex = &prev_ex, *pey = &prev_ey;
    int prev_color = get_color();
    get_start_point(psx, psy);
    get_end_point(pex, pey);
    set_color(0);

    for (int y = Y_MIN; y < Y_BOUND; ++y) {
        draw_line_from_to(X_MIN, y, X_MAX, y);
    }

    set_start_point(prev_sx, prev_sy);
    set_end_point(prev_ex, prev_ey);
    set_color(prev_color);
}

// Read/Write SW and LEDs

int get_all_switches() {
    return *SW;
}

int get_switch(int index) {
    return (*SW >> index) & 1;
}

int get_all_ledr() {
    return *LEDR;
}

int get_ledr(int index) {
    return (*LEDR >> index) & 1;
}

void set_ledr(int index, int value) {
    if (value)
        turn_on_ledr(index);
    else
        turn_off_ledr(index);
}

void turn_on_ledr(int index) {
    *LEDR = *LEDR | (1 << index);
}

void turn_off_ledr(int index) {
    *LEDR = *LEDR & (0x3FF ^ (1 << index));
}