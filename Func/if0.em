
//set the selected test as comment
macro SetIf0()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	InsBufLine(hbuf,sel.lnLast + 1,"#endif")
	InsBufLine(hbuf,sel.lnFirst,"#if 0")
}
macro SetIf0AndElse()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	InsBufLine(hbuf,sel.lnLast + 1,"#endif")
	InsBufLine(hbuf,sel.lnLast + 1,"	")
	InsBufLine(hbuf,sel.lnLast + 1,"#else")
	InsBufLine(hbuf,sel.lnFirst,"#if 0")
	SetBufIns (hbuf, sel.lnLast +3, 1)
}

//reset the comment to code.
macro ClrIf0()
{
	hbuf = GetCurrentBuf()
	LineCur = GetBufLnCur (hbuf)
	LineCnt = GetBufLineCount (hbuf)
	FindHead = 0;
	FindEnd = 0;
	lnHead = 0;
	lnEnd = 0;
	nestLev = 0;
	ln = LineCur
	str = ""

	//find string "#if 0"
	while(1)
	{
		str = GetBufLine (hbuf, ln)
		if(str == "#if 0")
		{
			if(nestLev > 0)
			{
				nestLev = nestLev - 1
			}
			else
			{
				lnHead = ln
				break;
			}
		}
		else if(str == "#endif")
		{
			nestLev = nestLev + 1
		}

		ln = ln - 1
		if(ln == 0)
		{
			Msg("Can not find \"#if 0\"");
			return;
		}
	}

	//find string "#endif"
	ln = LineCur
	nestLev = 0;
	while(1)
	{
		str = GetBufLine (hbuf, ln)
		if(str == "#endif")
		{
			if(nestLev > 0)
			{
				nestLev = nestLev - 1
			}
			else
			{
				lnEnd = ln
				break;
			}
		}
		else if(str == "#if 0")
		{
			nestLev = nestLev + 1
		}

		ln = ln + 1
		if(ln == LineCnt)
		{
			Msg("Can not find \"#endif\"");
			return;
		}
	}

	ln = lnEnd
	DelBufLine (hbuf, ln)
	ln = lnHead
	DelBufLine (hbuf, ln)
}


