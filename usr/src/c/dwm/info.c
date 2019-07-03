#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>

#include "info.h"

void
initinfo(const int gappx, const int barheight, const int barpos,
         const int numtags, const int borderpx, const int floatbar,
         const int visbar)
{
    /* make necessary directories */
    char *dirs[7] = {"/tmp/info/dwm", "/tmp/info/dwm/misc", "/tmp/info/dwm/tag",
                     "/tmp/info/dwm/layout", "/tmp/info/dwm/borders", "/tmp/info/dwm/bar",
                     "/tmp/info/dwm/colors"};

    for (int i = 0; i < 7; i++)
        mkdir(dirs[i], 0777);

    for (int i = 1; i < numtags; i++) {
        char buf[20];
        snprintf(buf, sizeof(buf), "/tmp/info/dwm/tag/%d", i);
        FILE *f = fopen(buf, "w");
        fprintf(f, "%d", 0);
        fclose(f);
    }

    FILE *fnumtags = fopen("/tmp/info/dwm/tag/num", "w");
    fprintf(fnumtags, "%d", numtags);
    fclose(fnumtags);

    FILE *fctag = fopen("/tmp/info/dwm/tag/current", "w");
    fprintf(fctag, "1");
    fclose(fctag);

    FILE *fcl = fopen("/tmp/info/dwm/layout/current", "w");
    fprintf(fcl, "0");
    fclose(fcl);

    FILE *fgappx = fopen("/tmp/info/dwm/misc/gappx", "w");
    fprintf(fgappx, "%d", gappx);
    fclose(fgappx);

    FILE *fborderpx = fopen("/tmp/info/dwm/borders/size", "w");
    fprintf(fborderpx, "%d", borderpx);
    fclose(fborderpx);

    FILE *fbar_height = fopen("/tmp/info/dwm/bar/height", "w");
    fprintf(fbar_height, "%d", barheight);
    fclose(fbar_height);

    FILE *fbarpos = fopen("/tmp/info/dwm/bar/pos", "w");
    fprintf(fbarpos, "%d", barpos);
    fclose(fbarpos);

    FILE *ffloatbar = fopen("/tmp/info/dwm/bar/floating", "w");
    fprintf(ffloatbar, "%d", floatbar);
    fclose(ffloatbar);

    FILE *fvisbar = fopen("/tmp/info/dwm/bar/visible", "w");
    fprintf(fvisbar, "%d", visbar);
    fclose(fvisbar);
}

void
infocurrenttag(int i)
{
    FILE *f = fopen("/tmp/info/dwm/tag/current", "w");
    fprintf(f, "%d", i);
    fclose(f);
}

void
infocurrentlayout(char *i)
{
    FILE *f = fopen("/tmp/info/dwm/layout/current", "w");
    fprintf(f, "%s", i);
    fclose(f);
}

void
infotag(int tag, int state)
{
    /* is tag occupied or empty or urgent */
    /* 0 - empty; 1 - occupied; 2 - urgent */
    char buf[50];
    snprintf(buf, sizeof(buf), "/tmp/info/dwm/tag/%d", tag);
    FILE *f = fopen(buf, "w");
    fprintf(f, "%d", state);
    fclose(f);
}

void
infocolors(const char *colors[][3])
{
    FILE *fborsel = fopen("/tmp/info/dwm/borders/selcol", "w");
    fprintf(fborsel, "%s", colors[1][2]);
    fclose(fborsel);

    FILE *fbornorm = fopen("/tmp/info/dwm/borders/normcol", "w");
    fprintf(fbornorm, "%s", colors[0][2]);
    fclose(fbornorm);

    FILE *fnormfg = fopen("/tmp/info/dwm/colors/normfg", "w");
    fprintf(fnormfg, "%s", colors[0][0]);
    fclose(fnormfg);

    FILE *fnormbg = fopen("/tmp/info/dwm/colors/normbg", "w");
    fprintf(fnormbg, "%s", colors[0][1]);
    fclose(fnormbg);

    FILE *fselfg = fopen("/tmp/info/dwm/colors/selfg", "w");
    fprintf(fselfg, "%s", colors[1][0]);
    fclose(fselfg);

    FILE *fselbg = fopen("/tmp/info/dwm/colors/selbg", "w");
    fprintf(fselbg, "%s", colors[1][1]);
    fclose(fselbg);
}

void
infoname(const char name[])
{
    FILE *fname = fopen("/tmp/info/dwm/misc/title", "w");
    fprintf(fname, "%s", name);
    fclose(fname);
}
