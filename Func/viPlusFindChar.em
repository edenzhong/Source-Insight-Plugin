macro viPlusFindChar()
{
	var hwnd;
	hwnd = GetCurrentWnd()
	var hbuf
	hbuf = GetCurrentBuf ()
	var cursel
	cursel = viDefaultSelect()
	

	ch = getchar()

	cursel = GetWndSel (hwnd)
	ln = GetBufLnCur (hbuf)
	len = GetBufLineLength (hbuf, ln)
	if ( len > cursel.ichfirst )
	{
		str = GetBufLine (hbuf, ln)
		str = strmid (str, cursel.ichFirst+1, len)
		idx = FindStr(str,ch)
		if ( idx >= 0 )
		{
			idx = idx + 1
			while(idx>0)
			{
				Cursor_Right
				idx = idx - 1
			}
		}
	}
}
macro viPlusFindCharR()
{
	var hwnd;
	hwnd = GetCurrentWnd()
	var hbuf
	hbuf = GetCurrentBuf ()
	var cursel
	cursel = viDefaultSelect()
	
	ch = getchar()
	cursel = GetWndSel (hwnd)
	if ( cursel.ichfirst > 0 )
	{
		ln = GetBufLnCur (hbuf)
		str = GetBufLine (hbuf, ln)
		str = strmid(str,0,cursel.ichfirst)
		idx = FindStrR(str,ch)
		step = cursel.ichfirst - idx;
		if ( step > 0 )
		{
			Beginning_of_Selection
			while(step>0)
			{
				Cursor_Left
				step = step -1
			}
		}
	}
}

