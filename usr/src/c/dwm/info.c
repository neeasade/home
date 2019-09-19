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
    char *dirs[7] = {"/tmp/info/wm", "/tmp/info/wm/misc", "/tmp/info/wm/tag",
                     "/tmp/info/wm/layout", "/tmp/info/wm/borders", "/tmp/info/wm/bar",
                     "/tmp/info/wm/colors"};

    for (int i = 0; i < 7; i++)
        mkdir(dirs[i], 0777);

    for (int i = 1; i < numtags; i++) {
        char buf[20];
        snprintf(buf, sizeof(buf), "/tmp/info/wm/tag/%d", i);
        FILE *f = fopen(buf, "w");
        fprintf(f, "%d", 0);
        fclose(f);
    }

    FILE *fnumtags = fopen("/tmp/info/wm/tag/num", "w");
    fprintf(fnumtags, "%d", numtags);
    fclose(fnumtags);

    FILE *fctag = fopen("/tmp/info/wm/tag/current", "w");
    fprintf(fctag, "1");
    fclose(fctag);

    FILE *fcl = fopen("/tmp/info/wm/layout/current", "w");
    fprintf(fcl, "0");
    fclose(fcl);

    FILE *fgappx = fopen("/tmp/info/wm/misc/gappx", "w");
    fprintf(fgappx, "%d", gappx);
    fclose(fgappx);

    FILE *fborderpx = fopen("/tmp/info/wm/borders/size", "w");
    fprintf(fborderpx, "%d", borderpx);
    fclose(fborderpx);

    FILE *fbar_height = fopen("/tmp/info/wm/bar/height", "w");
    fprintf(fbar_height, "%d", barheight);
    fclose(fbar_height);

    FILE *fbarpos = fopen("/tmp/info/wm/bar/pos", "w");
    fprintf(fbarpos, "%d", barpos);
    fclose(fbarpos);

    FILE *ffloatbar = fopen("/tmp/info/wm/bar/floating", "w");
    fprintf(ffloatbar, "%d", floatbar);
    fclose(ffloatbar);

    FILE *fvisbar = fopen("/tmp/info/wm/bar/visible", "w");
    fprintf(fvisbar, "%d", visbar);
    fclose(fvisbar);
}

void
infocurrenttag(int i)
{
    FILE *f = fopen("/tmp/info/wm/tag/current", "w");
    fprintf(f, "%d", i);
    fclose(f);
}

void
infocurrentlayout(char *i)
{
    FILE *f = fopen("/tmp/info/wm/layout/current", "w");
    fprintf(f, "%s", i);
    fclose(f);
}

void
infotag(int tag, int state)
{
    /* is tag occupied or empty or urgent */
    /* 0 - empty; 1 - occupied; 2 - urgent */
    char buf[50];
    snprintf(buf, sizeof(buf), "/tmp/info/wm/tag/%d", tag);
    FILE *f = fopen(buf, "w");
    fprintf(f, "%d", state);
    fclose(f);
}

void
infocolors(const char *colors[][3])
{
    FILE *fborsel = fopen("/tmp/info/wm/borders/selcol", "w");
    fprintf(fborsel, "%s", colors[1][2]);
    fclose(fborsel);

    FILE *fbornorm = fopen("/tmp/info/wm/borders/normcol", "w");
    fprintf(fbornorm, "%s", colors[0][2]);
    fclose(fbornorm);

    FILE *fnormfg = fopen("/tmp/info/wm/colors/normfg", "w");
    fprintf(fnormfg, "%s", colors[0][0]);
    fclose(fnormfg);

    FILE *fnormbg = fopen("/tmp/info/wm/colors/normbg", "w");
    fprintf(fnormbg, "%s", colors[0][1]);
    fclose(fnormbg);

    FILE *fselfg = fopen("/tmp/info/wm/colors/selfg", "w");
    fprintf(fselfg, "%s", colors[1][0]);
    fclose(fselfg);

    FILE *fselbg = fopen("/tmp/info/wm/colors/selbg", "w");
    fprintf(fselbg, "%s", colors[1][1]);
    fclose(fselbg);
}

void
infoname(const char name[])
{
    FILE *fname = fopen("/tmp/info/wm/misc/title", "w");
    fprintf(fname, "%s", name);
    fclose(fname);
}
