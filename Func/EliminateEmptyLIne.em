
macro EliminateEmptyLine()
{
	var hwnd

	hwnd = GetCurrentWnd ()
	if ( hwnd == hnil )
	{
		return ;
	}
	var hbuf
	hbuf = GetWndBuf (hwnd)

	var ln1st
	var lnlast

	ln1st = GetWndSelLnFirst (hwnd)
	lnlast = GetWndSelLnLast (hwnd)

	var lncont
	var ln
	ln = ln1st
	while ( ln <= lnlast )
	{
		lncont = GetBufLine(hbuf, ln)
		if ( FindNotOf(lncont," 	") >= 0 )
		{
			// found some not empty char, this is not an empty line
			ln = ln + 1
		}
		else
		{
			// this line only contain empty char
			DelBufLine (hbuf, ln)
			lnlast = lnlast - 1
		}
	}
}

