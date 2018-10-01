const char *colorname[] = {
	/* 8 normal colors */
	[0] = "black",
	[1] = "red3",
	[2] = "green3",
	[3] = "yellow3",
	[4] = "blue2",
	[5] = "magenta3",
	[6] = "cyan3",
	[7] = "gray90",

	/* 8 bright colors */
	[8] = "gray50",
	[9] = "red",
	[10] = "green",
	[11] = "yellow",
	[12] = "#5c5cff",
	[13] = "magenta",
	[14] = "cyan",
	[15] = "white",
	
	/* more colors can be added after 255 to use with DefaultXX */
		[256] = "#cccccc",
		[257] = "#555555",
		[258] = "#091018",
};

unsigned int defaultfg = 7;
unsigned int defaultbg = 258;
unsigned int defaultcs = 256;
unsigned int defaultrcs = 256;