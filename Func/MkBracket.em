
macro SetIncluded(first,second)
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	if ( sel.fExtended )
	{
		ln = sel.lnLast
		strcont = getbufline(hbuf,ln)
		strtmp = strmid(strcont,0,sel.ichLim)
		strtmp = cat(strtmp,second)
	
		tmp = strmid(strcont,sel.ichLim,strlen(strcont))
		strtmp = cat(strtmp,tmp)
		delbufline(hbuf,ln)
		insbufline(hbuf,ln,strtmp)
		
		ln = sel.lnFirst
		strcont = getbufline(hbuf,ln)
		strtmp = strmid(strcont,0,sel.ichFirst)
		strtmp = cat(strtmp,first)
	
		tmp = strmid(strcont,sel.ichFirst,strlen(strcont))
		strtmp = cat(strtmp,tmp)
		delbufline(hbuf,ln)
		insbufline(hbuf,ln,strtmp)
		sel.ichLim = sel.ichLim +1
		if(sel.lnLast == sel.LnFirst)
		{
			sel.ichLim = sel.ichLim +1
		}
		SetWndSel(hwnd,sel)
	}
	else
	{
		SetBufSelText(hbuf, first)
		SetBufSelText(hbuf, second)
		Cursor_Left
	}
}
macro MkParenthesis()
{
	SetIncluded("(",")")
}
macro MkBracket()
{
	SetIncluded("[","]")
}
macro MkQuotation()
{
	SetIncluded( "\"","\"")
}

