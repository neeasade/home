/* See LICENSE file for copyright and license details. */
#define CWD   "cwd: "
#define CURSR " > "
#define EMPTY "   "

int mtimeorder  = 0; /* Set to 1 to sort by time modified */
int idletimeout = 0; /* Screensaver timeout in seconds, 0 to disable */
int showhidden  = 0; /* Set to 1 to show hidden files by default */
char *idlecmd   = "rain"; /* The screensaver program */

struct assoc assocs[] = {
	{ "\\.(avi|mp4|mkv|mp3|ogg|flac|mov)$", "mpv" },
	{ "\\.(png|jpg|gif)$", "sxiv" },
	{ "\\.(html|svg)$", "firefox" },
	{ "\\.pdf$", "mupdf" },
	{ "\\.sh$", "sh" },
	{ ".", "nvim" },
};

struct key bindings[] = {
	/* Quit */
	{ 'q',            SEL_QUIT },
	/* Back */
	{ 'h',            SEL_BACK },
	/* Inside */
	{ KEY_ENTER,      SEL_GOIN },
	{ 'l',            SEL_GOIN },
	/* Filter */
	{ '/',            SEL_FLTR },
	{ '&',            SEL_FLTR },
	/* Next */
	{ 'j',            SEL_NEXT },
	/* Previous */
	{ 'k',            SEL_PREV },
	/* Page down */
	{ KEY_NPAGE,      SEL_PGDN },
	/* Page up */
	{ KEY_PPAGE,      SEL_PGUP },
	/* Home */
	{ 'g',            SEL_HOME },
	/* End */
	{ 'G',            SEL_END },
	/* Change dir */
	{ 'c',            SEL_CD },
	{ CONTROL('H'),   SEL_CDHOME    },
    { CONTROL('S'),   SEL_CDHOMESRC },
    { CONTROL('T'),   SEL_CDHOMETMP },
    { CONTROL('D'),   SEL_CDHOMEDL  },
    { CONTROL('W'),   SEL_CDHOMEWLL },
    { CONTROL('E'),   SEL_CDHOMEETC },
    { CONTROL('C'),   SEL_CDHOMECHE },
    { CONTROL('U'),   SEL_CDHOMEUSR },
    { CONTROL('R'),   SEL_CDHOMERPS },
	/* Toggle hide .dot files */
	{ '.',            SEL_TOGGLEDOT },
	/* Toggle sort by time */
	{ 't',            SEL_MTIME },
	{ CONTROL('L'),   SEL_REDRAW },
	/* Run command */
	{ 'z',            SEL_RUN, "top" },
	{ '!',            SEL_RUN, "sh", "SHELL" },
	/* Run command with argument */
	{ 'e',            SEL_RUNARG, "nvim", "EDITOR" },
	{ 'p',            SEL_RUNARG, "nvim", "PAGER" },
};
