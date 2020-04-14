// This package assumes every line/column number is relative except for
// GotoPos. Reason: querying for line/column number is quite hard and
// I'm completely clueless on how to do.
// All escape sequences are from http://www.termsys.demon.co.uk/vtansi.htm
package ui

import (
	"fmt"
	"os"
)

// Initialise the TUI.
// This saves the current cursor position and clears the screen
func Init() {
	fmt.Printf(
		// Save cursor position
		"\033[s" +
		// Clear the screen
		"\033[2J" +
		// Disable line wrapping
		"\033[7l")
}

// Move the cursor to (x,y)
// y corresponds to the line number
// x corresponds to the column number
func GotoPos(x, y int) {
	fmt.Printf("\033[%d;%dH", y, x)
}

// Like GotoPos but only changes the line number
// Negative numbers are also accepted
func GotoLine(y int) {
	if y < 0 {
		// Move cursor down
		fmt.Printf("\033[%dA", -y)
	} else {
		// Move cursor up
		fmt.Printf("\033[%dB", y)
	}
}

// Like GotoLine but changes the column number
// Negative number means the cursor will move to the left
func GotoCol(x int) {
	if x < 0 {
		// Move cursor to the left
		fmt.Printf("\033[%dC", -x)
	} else {
		// Move cursor to the right
		fmt.Printf("\033[%dD", x)
	}
}

// Move the highlighted line to y
// and redraw the string. This is slightly better than
// redrawing the entire screen on each keypress
func SetHighlightLine(y int, s string) {
	// Move to line y
	GotoLine(y)
	fmt.Printf(
		// Erase the current line
		"\033[2K" +
		// Write > and then the selected line
		"> %s",
		s)
}

// Highlight (reverse) line y
func HighlightLine(y int, s string) {
	// Save current cursor position
	fmt.Printf("\0337")
	// Move to line y
	GotoLine(y)
	fmt.Printf(
		// Reverse
		"\033[7m" +
		// Back to normal
		"%s\033[0m" +
		// Move back to saved position
		"\0338",
		s)
	// Move back to saved position
	fmt.Printf("\0338")
}
