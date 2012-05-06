
macro ReverseLines()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)
	if ( sel.lnFirst == sel.lnLast )
	{
		return
	}

	ln = sel.lnFirst
	lntar = sel.lnLast + 1
	while( ln <= sel.lnLast )
	{
		s = GetBufLine(hbuf,ln )
		InsBufLine (hbuf, lntar, s)
		ln = ln + 1
	}
	ln = sel.lnLast
	while(ln >= sel.lnFirst )
	{
		DelBufLine (hbuf, ln)
		ln = ln - 1
	}
}

