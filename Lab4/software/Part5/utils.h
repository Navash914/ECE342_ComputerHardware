#ifndef ECE342_UTILS_H
#define ECE342_UTILS_H

#define SW_BASE 0x11020
#define LEDR_BASE 0x11030
#define LDA_BASE 0x11000

#define POLL_MODE 1
#define MODE_OFFSET 0
#define STATUS_OFFSET 1
#define GO_OFFSET 2
#define SP_OFFSET 3
#define EP_OFFSET 4
#define COLOR_OFFSET 5

#define X_MIN 0
#define X_MAX 335
#define X_BOUND 336
#define Y_MIN 0
#define Y_MAX 209
#define Y_BOUND 210

#define DELAY_TIMER 10000000

#define DELAY for (int delay=0; delay<DELAY_TIMER; ++delay);

extern volatile int *LEDR;
extern volatile int *SW;
extern volatile int *LDA;

// Line Drawing Functions

void wait_if_poll_mode();

int get_mode();
void set_mode(int mode);

int get_start_point(int *x, int *y);
void set_start_point(int x, int y);

int get_start_point(int *x, int *y);
void set_end_point(int x, int y);

int get_color();
void set_color(int color);

void draw_line();
void draw_line_to(int x, int y);
void draw_line_from_to(int x0, int y0, int x1, int y1);

void clear_screen();

// Read/Write SW and LEDs

int get_all_switches();
int get_switch(int index);

int get_all_ledr();
int get_ledr(int index);
void set_ledr(int index, int value);
void turn_on_ledr(int index);
void turn_off_ledr(int index);

#endif