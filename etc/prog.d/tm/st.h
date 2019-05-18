const char *colorname[] = {
	/* 8 normal colors */
	[0] = "#X0", /* black   */
	[1] = "#X7",    /* red     */
	[2] = "#X7",  /* green   */
	[3] = "#X7", /* yellow  */
	[4] = "#X7",   /* blue    */
	[5] = "#X7",/* magenta */
	[6] = "#X7",   /* cyan    */
	[7] = "#X7",  /* white   */

	/* 8 bright colors */
	[8] = "#X7",    /* black   */
	[9] = "#X7",      /* red     */
	[10] = "#X7",   /* green   */
	[11] = "#X7",  /* yellow  */
	[12] = "#X7", /* blue    */
	[13] = "#X7", /* magenta */
	[14] = "#X7",    /* cyan    */
	[15] = "#X7",   /* white   */

	/* more colors can be added after 255 to use with Default#XX */
	[256] = "#X7", /* foreground */
	[257] = "#X0", /* background */
};

unsigned int defaultfg = 256;
unsigned int defaultbg = 257;
unsigned int defaultcs = 256;
