#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>

int
main() {
    struct winsize ws;
    ioctl(STDIN_FILENO, TIOCGWINSZ, &ws);

    printf("LINES=%d\n", ws.ws_row);
    printf("COLUMS=%d\n", ws.ws_col);
    printf("XPX=%d\n", ws.ws_xpixel);
    printf("YPX=%d\n", ws.ws_ypixel);

    return 0;
}
