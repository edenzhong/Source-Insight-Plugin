
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
/***********************************************************
*	move to middle
***********************************************************/
macro ui_mov_to_mid_win()
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
	select_line
}
macro MovCursorToMiddle(up_pos,down_pos)
{
	if ( down_pos > up_pos )
	{
		var step
		step = down_pos - up_pos;
		step = step / 2
		var hbuf
		hbuf = GetCurrentBuf ()
		SetBufIns (hbuf, up_pos+step, 0)
		select_line
	}
}
macro MoveMiddle(dir_up)
{
	var hwnd;
	hwnd = GetCurrentWnd()
	var hbuf
	hbuf = GetWndBuf (hwnd)
	var up_pos;
	var down_pos;
	if ( dir_up )
	{
		up_pos = GetWndVertScroll (hwnd)
		down_pos = GetWndSelLnFirst (hwnd)
	}
	else
	{
		up_pos = GetWndSelLnFirst (hwnd)
		down_pos = GetWndVertScroll (hwnd)+GetWndLineCount (hwnd)
	}
	StartMsg ("C-A-J to move down, C-A-K to move up")
	while(1)
	{
		MovCursorToMiddle(up_pos,down_pos)
		var key
		var ch
		key = getkey()
		ch = CharFromKey(key)
		if ( "J" == ch )
		{
			if ( IsCtrlKeyDown(key) )
			{
				if ( IsAltKeyDown(key) )
				{
					var hwnd;
					hwnd = GetCurrentWnd()
					up_pos = GetWndSelLnFirst (hwnd)
					continue
				}
			}
		}
		else if ( "K" == ch )
		{
			if ( IsCtrlKeyDown(key) )
			{
				if ( IsAltKeyDown(key) )
				{
					var hwnd;
					hwnd = GetCurrentWnd()
					down_pos = GetWndSelLnFirst (hwnd)
					continue
				}
			}
		}
		return
	}
}
macro MoveUpMiddle()
{
	MoveMiddle(1)
}
macro MoveDownMiddle()
{
	MoveMiddle(0)
}

