const char *colorname[] = {
	/* 8 normal colors */
	[0] = "#2d3436", /* black   */
	[1] = "#d02811",    /* red     */
	[2] = "#3c7a0c",  /* green   */
	[3] = "#e9b647", /* yellow  */
	[4] = "#3f93ae",   /* blue    */
	[5] = "#fbd3da",/* magenta */
	[6] = "#55cbae",   /* cyan    */
	[7] = "gray90",  /* white   */
                                  
	/* 8 bright color  s */
	[8] = "#4a4a4f",    /* black   */
	[9] = "#d62c16",      /* red     */
	[10] = "#49940f",   /* green   */
	[11] = "#c4952d",  /* yellow  */
	[12] = "#1a7490", /* blue    */
	[13] = "#e9b3c8", /* magenta */
	[14] = "#1bcb9f",    /* cyan    */
	[15] = "white",   /* white   */
	
	/* more colors can be added after 255 to use with DefaultXX */
		[256] = "#ffffff",
		[257] = "#2d3436",
};

unsigned int defaultfg = 7;
unsigned int defaultbg = 257;
unsigned int defaultcs = 256;
