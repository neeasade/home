/* -b  option; if 0, dmenu appears at bottom     */
static int topbar = 1;

/* -F option; if 0, dont use fuzzy match */
static int fuzzy = 1;

/* -fn option overrides fonts[0]; default X11 font or font set */
/* static const char *fonts[] = {
    "Share Tech Mono:pixelsize=13"
};*/

/* -p  option; prompt to the left of input field */
static const char *prompt      = NULL;

/* border width in pixels. can be overriden with the -bp flag */
static unsigned int borderpx   = 0;

/* includ theme */
#include "/home/viz/usr/local/share/cache/tm/dmenu.h"

/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
