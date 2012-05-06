
macro CursorDown3Line()
{
	cursor_down
	cursor_down
	cursor_down
}

macro CursorUp3Line()
{
	cursor_Up
	cursor_Up
	cursor_Up
}

macro CursorLeft3Char()
{
	cursor_left
	cursor_left
	cursor_left
}

macro CursorRight3Char()
{
	cursor_right
	cursor_right
	cursor_right
}

macro MovToNextNonLowerChar()
{
	LoadSearchPattern("[^a-z0-9]", true, true, false);
	Search_Forward
	Beginning_of_Selection
}

macro MovToPreviousNonLowerChar()
{
	LoadSearchPattern("[^a-z0-9]", true, true, false);
	Search_backward
	Beginning_of_Selection
}
/*
macro SelToNextDifferentTypeChar()
{
	
}

macro SelToPreviousDifferentTypeChar()
{
	
}
*/
macro MovToMiddle()
{
	var hwnd;
	hwnd = GetCurrentWnd()
	var hbuf
	hbuf = GetWndBuf (hwnd)

	var lncnt
	
	lncnt = GetWndLineCount (hwnd)
	if ( lncnt > 0 )
	{
		lncnt = lncnt / 2
	}
	var lnlocate
	lnlocate = GetWndVertScroll (hwnd)+ lncnt
	SetBufIns (hbuf, lnlocate, 0)
}

