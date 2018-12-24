/* See LICENSE file for copyright and license details. */
/* appearance */
static const unsigned int BORDERPX  = 0;        /* border pixel of windows */
static const unsigned int GAP_PX    = 6;        /* useless gaps in px */
static const unsigned int start_borders = 3; //0 means no borders and yes gaps. 1 means no gaps and yes borders. 2 means no borders and no gaps, 3 means gaps and borders
static const unsigned int snap      = 0;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int BAR_HEIGHT         = 20; // in pixels
static const int topbar             = 1;        /* 0 means bottom bar */
static const int bar_gap            = 0; // whether to have gaps around bar
static const int two_borders        = 1;        /* whether use two borders */ //TODO
static const int monocle_fullscreen = 0;       /* whether to disable border and gap in monocle layout */ //TODO
//static const int float_border 			= 1; // 0 means keep border no matter the number of client is in floating. 1 means no border if only one floating client is present.
//static const char *fonts[]          = {"Terminus (TTF):size=9" };
static const char *fonts[]          = { "scientifica:size=10" };
static const char dmenufont[]       = "scientifica :size=10";
//theme include
//#include "themes/thicc.h"
//#include "themes/pink.h"
//#include "themes/default.h"
//#include "themes/base16-ocean-dark.h"
//#include "themes/greyscale.h"
//#include "themes/viking.h"
#include "/home/the_human/var/cache/tm/colors/colors_dwm.h"

/* tagging */
static const int NUM_WORKSPACES = 8;
static const char *tags[] = { "0", "1", "2", "3", "4", "5", "6", "7" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     iscentered     isfloating   isbordered   monitor */
	{ "Gimp",     NULL,       NULL,       0,            0,             1,           1,            -1 },
	{ "Firefox",  NULL,       NULL,       1 << 1,       0,             0,           1,            -1 },
	{ "feh",      NULL,       "feh",      0,            1,             1,		    0,            -1 },
	{ "st",       NULL,       "floating-st", 0,         0,             1,           1,            -1 },
    { "st",       NULL,       "todoterm", 0,            0,             1,           0,            -1 },
	{ "Minecraft 1.13", NULL, "Minecraft 1.13", 0, 		1, 		       1, 			1,            -1 },
    { "MuPDF",    NULL,       NULL,       0,            1,             1,           0,            -1 },
    { "mpv",      NULL,       NULL,       0,            1,             1,           0,            -1 },
};

/* layout(s) */
static const float mfact     = 0.60; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

#include "layouts.c"

static int NUM_LAYOUTS = 8;
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
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
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },
/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dash", "-c", "$HOME/bin/menu run", NULL };
static const char *termcmd[]  = { "tabbed", "-c","-r 2", "st", "-w", "", NULL };
static const char scratchpadname[] = "scratchpad";
static const char *scratchpadcmd[] = { "st", "-t", scratchpadname, "-g", "120x34", NULL };
static const char *drawst[] = { "dash", "-c", "${HOME}/bin/draw_st", NULL };
static const char *hiddendmenudir[] = { "dash", "-c", "${HOME}/bin/dmenu_dir -h 1", NULL };
static const char *dmenudir[] = { "dash", "-c", "${HOME}/bin/dmenu_dir -h 0", NULL };
static const char *center_win[] = { "bash", "-c", "${HOME}/bin/center_win", NULL };
static const char *fullwin[] = { "dash", "-c", "${HOME}/bin/fswin", NULL };

#include "zoomswap.c"
#include "movestack.c"
static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY|ShiftMask,             XK_g,      togglegaps,     {0} },
	{ MODKEY|ShiftMask,             XK_b,      toggleborder,   {0} },
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
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
/*  { MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_u,      setlayout,      {.v = &layouts[3]} },
	{ MODKEY,                       XK_c,      setlayout,      {.v = &layouts[4]} },
	{ MODKEY,                       XK_q,      setlayout,      {.v = &layouts[5]} },
	{ MODKEY,                       XK_s,      setlayout,      {.v = &layouts[6]} },
	{ MODKEY,                       XK_a,      setlayout,      {.v = &layouts[7]} }, */
    { SUPERKEY,                     XK_1,      setlayout,      {.v = &layouts[0]} }, // tiling
    { SUPERKEY,                     XK_5,      setlayout,      {.v = &layouts[1]} }, // floating
    { SUPERKEY,                     XK_3,      setlayout,      {.v = &layouts[2]} }, // monocle
    { SUPERKEY,                     XK_2,      setlayout,      {.v = &layouts[3]} }, // bottom stack
    { SUPERKEY,                     XK_4,      setlayout,      {.v = &layouts[4]} }, // deck
    { SUPERKEY,                     XK_6,      setlayout,      {.v = &layouts[5]} },
    { SUPERKEY,                     XK_7,      setlayout,      {.v = &layouts[6]} },
    { SUPERKEY,                     XK_8,      setlayout,      {.v = &layouts[7]} },
    { SUPERKEY,                     XK_space,  setlayout,      {0} },
    { MODKEY|ShiftMask,             XK_f,      spawn,          {.v = hiddendmenudir} },
    { MODKEY|ShiftMask|ControlMask, XK_f,      spawn,          {.v = dmenudir} },
    { MODKEY,           XK_c,      spawn,          {.v = center_win} },
    { MODKEY,                       XK_f,      spawn,          {.v = fullwin} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
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
/*	TAGKEYS(                        XK_9,                      8)
	TAGKEYS(                        XK_0,                      9) */
	{ MODKEY|ShiftMask,             XK_q,      quit,           {1} },
	{ MODKEY|ControlMask|ShiftMask, XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkRootWin, 		    0, 		        Button3, 	    spawn, 		    {.v = drawst} },
};
