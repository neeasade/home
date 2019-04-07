static const char normbg[]       = "#X0";
static const char normfg[]       = "#X7";
static const char normborder[]   = "#X8";
static const char selfg[]        = "#X15";
static const char selbg[]        = "#X8";
//static const char selborder[]    = "#X15";
static const char selborder[]    = "#X8";

static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { normfg,    normbg,    normborder },
	[SchemeSel]  = { selfg,     selbg,     selborder  },
};
