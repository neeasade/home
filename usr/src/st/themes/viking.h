const char *colorname[] = {
	/* 8 normal colors */
	[0] = "#2b2c2b", /* black   */
	[1] = "#c86d6d",    /* red     */
	[2] = "#b7c159",  /* green   */
	[3] = "#e3cf78", /* yellow  */
	[4] = "#7094b1",   /* blue    */
	[5] = "#cb93c6",/* magenta */
	[6] = "#7fcdb6",   /* cyan    */
	[7] = "#d3d8de",  /* white   */
                                  
	/* 8 bright colors */
	[8] = "#535555",    /* black   */
	[9] = "#ba6a6a",      /* red     */
	[10] = "#a8b155",   /* green   */
	[11] = "#d5c271",  /* yellow  */
	[12] = "#6587a3", /* blue    */
	[13] = "#bc87b7", /* magenta */
	[14] = "#76bda8",    /* cyan    */
	[15] = "#c9ced6",   /* white   */
	
	/* more colors can be added after 255 to use with DefaultXX */
	[256] = "#d3d8de",
	[257] = "#6f7270",
};

unsigned int defaultfg = 256;
unsigned int defaultbg = 0;
unsigned int defaultcs = 256;
unsigned int defaultrcs = 256;
