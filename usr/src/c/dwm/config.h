// TODO: add a issticky rule
/* border pixel of windows */
static const unsigned int BORDERPX  = 1;

/* useless gaps in px */
static const unsigned int GAP_PX    = 2;

/*
 * 0 means gaps and no borders
 * 1 means borders and no gaps
 * 2 means no borders and no gaps
 * 3 means gaps and borders
 *
 */
static const unsigned int start_borders = 3;

/* snap pixel */
static const unsigned int snap      = 0;

/* bar height in pixels */
static const int BAR_HEIGHT         = 0;

/*
 * 0 means bottom bar
 * 1 means top bar
 * 2 means left bar
 *
 */
static const int barpos             = 2;

/* 1 means have gaps around bar and root window */
static const int bar_gap            = 0;

/* whether to disable borders and gap if only a single window is open */
static const int fullscreen_one_window = 1;

/* include themes */
//#include "themes/thicc.h"
//#include "themes/pink.h"
//#include "themes/default.h"
//#include "themes/base16-ocean-dark.h"
//#include "themes/greyscale.h"
//#include "themes/viking.h"
#include "/home/viz/var/cache/tm/dwm.h"

/* tagging */
/* number of workspaces */
static const int NUM_WORKSPACES     = 8;
static const char *tags[]           = { "0", "1", "2", "3", "4", "0", "1", "2" };


static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     iscentered     isfloating   isbordered   monitor */
	{ "Gimp",     NULL,       NULL,       0,            0,             1,           1,            -1 },
	{ "Firefox",  NULL,       NULL,       1 << 1,       0,             0,           1,            -1 },
	{ "qutebrowser",NULL,     NULL,       1 << 1,       0,             0,           1,            -1 },
    { "Chromium", NULL,       NULL,       1 << 1,       0,             0,           1,            -1 },
	{ "feh",      NULL,       "feh",      0,            1,             1,		    0,            -1 },
	{ "st",       NULL,       "floating-st", 0,         0,             1,           1,            -1 },
    { "st",       NULL,       "todoterm", 0,            0,             1,           0,            -1 },
    { "st",       NULL,       "surf-download", 0,       1,             1,           1,            -1 },
    { "MuPDF",    NULL,       NULL,       0,            1,             1,           0,            -1 },
    { "mpv",      NULL,       NULL,       0,            1,             1,           0,            -1 },
    { "st",       NULL,       "scratchpad", 0,          1,             1,           0,            -1 },
};

/* factor of master area size [0.05..0.95] */
static const float mfact     = 0.60;

/* number of clients in master area */
static const int nmaster     = 1;

/* include layouts */
#include "layouts.c"

/* layouts symbol and their function */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },
	{ "><>",      NULL },
	{ "[M]",      monocle },
	{ "TTT",      bstack },
	{ "[]H",      deck  },
	{ "|M|",      centeredmaster },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
};

/* key definitions */
#define MODKEY Mod1Mask
#define SUPERKEY Mod4Mask
#define TAGKEYS(KEY,TAG)\
	{ MODKEY,                       KEY,      comboview,      {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      combotag,       {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* commands */
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "120x34", NULL };
static const char *drawst[] = { "dash", "-c", "/home/viz/bin/draw_st", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY|ShiftMask,             XK_g,      togglegaps,     {0} },
	{ MODKEY|ShiftMask,             XK_b,      toggleborder,   {0} },
	{ MODKEY,                       XK_grave,  togglescratch,  {.v = scratchpadcmd } },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_h,      setcfact,       {.f = +0.25} },
	{ MODKEY|ShiftMask,             XK_l,      setcfact,       {.f = -0.25} },
	{ MODKEY|ShiftMask,             XK_o,      setcfact,       {.f =  0.00} },
	{ MODKEY|ShiftMask,             XK_j,      movestack,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      movestack,      {.i = -1 } },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
    { SUPERKEY,                     XK_1,      setlayout,      {.v = &layouts[0]} }, // tiling
    { SUPERKEY,                     XK_5,      setlayout,      {.v = &layouts[1]} }, // floating
    { SUPERKEY,                     XK_3,      setlayout,      {.v = &layouts[2]} }, // monocle
    { SUPERKEY,                     XK_2,      setlayout,      {.v = &layouts[3]} }, // bottom stack
    { SUPERKEY,                     XK_4,      setlayout,      {.v = &layouts[4]} }, // deck
    { SUPERKEY,                     XK_6,      setlayout,      {.v = &layouts[5]} },
    { SUPERKEY,                     XK_7,      setlayout,      {.v = &layouts[6]} },
    { SUPERKEY,                     XK_8,      setlayout,      {.v = &layouts[7]} },
    { SUPERKEY,                     XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
    { MODKEY|ShiftMask,             XK_s,      togglesticky,   {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
  /*TAGKEYS(                        XK_0,                      9) */
	{ MODKEY|ShiftMask,             XK_q,      quit,           {1} },
	{ MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkClientWin or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkRootWin, 		    0, 		        Button3, 	    spawn, 		    {.v = drawst} },
};
