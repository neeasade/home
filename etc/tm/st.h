const char *colorname[] = {
	/* 8 normal colors */
	[0] = "#X0", /* black   */
	[1] = "#X1",    /* red     */
	[2] = "#X2",  /* green   */
	[3] = "#X3", /* yellow  */
	[4] = "#X4",   /* blue    */
	[5] = "#X5",/* magenta */
	[6] = "#X6",   /* cyan    */
	[7] = "#X7",  /* white   */

	/* 8 bright colors */
	[8] = "#X8",    /* black   */
	[9] = "#X9",      /* red     */
	[10] = "#X10",   /* green   */
	[11] = "#X11",  /* yellow  */
	[12] = "#X12", /* blue    */
	[13] = "#X13", /* magenta */
	[14] = "#X14",    /* cyan    */
	[15] = "#X15",   /* white   */

	/* more colors can be added after 255 to use with Default#XX */
	[256] = "#X7", /* foreground */
	[257] = "#X0", /* background */
};

unsigned int defaultfg = 256;
unsigned int defaultbg = 257;
unsigned int defaultcs = 256;
