/* Terminal colors (16 first used in escape sequence) */
static const char *colorname[] = {

  /* 8 normal colors */
  [0] = "#101010", /* black   */
  [1] = "#7c7c7c", /* red     */
  [2] = "#8e8e8e", /* green   */
  [3] = "#a0a0a0", /* yellow  */
  [4] = "#686868", /* blue    */
  [5] = "#747474", /* magenta */
  [6] = "#868686", /* cyan    */
  [7] = "#b9b9b9", /* white   */

  /* 8 bright colors */
  [8]  = "#525252", /* black   */
  [9]  = "#797979", /* red     */
  [10] = "#8d8c8c", /* green   */
  [11] = "#9c9c9c", /* yellow  */
  [12] = "#656565", /* blue    */
  [13] = "#727272", /* magenta */
  [14] = "#818181", /* cyan    */
  [15] = "#f7f7f7", /* white   */

  /* special colors */
  [256] = "#101010", /* background */
  [257] = "#b9b9b9", /* foreground */
};

/*
 * Default colors (colorname index)
 * foreground, background, cursor
 */
unsigned int defaultfg = 7;
unsigned int defaultbg = 0;
unsigned int defaultcs = 257;
unsigned int defaultrcs = 257;
