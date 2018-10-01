/* See LICENSE file for copyright and license details. */
/* Default settings; can be overriden by command line. */

static int topbar = 1;                      /* -b  option; if 0, dmenu appears at bottom     */
/* -fn option overrides fonts[0]; default X11 font or font set */
static const char *fonts[] = {
	"scientifica:size=10"
};
static const char *prompt      = NULL;      /* -p  option; prompt to the left of input field */
static unsigned int borderpx = 0;
static char *colborder = "#ffffff";
static const char *colors[SchemeLast][2] = {
	/*     fg         bg       */
    [SchemeNorm] = { "#fbd3da", "#2d3436" },
	[SchemeSel] = { "#e9b3c8", "#2d3436" },
	[SchemeOut] = { "#000000", "#00ffff" },
};
/* -l option; if nonzero, dmenu uses vertical list with given number of lines */
static unsigned int lines      = 0;

/*
 * Characters not considered part of a word while deleting words
 * for example: " /?\"&[]"
 */
static const char worddelimiters[] = " ";
