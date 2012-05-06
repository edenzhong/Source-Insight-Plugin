
//insert a comment
macro InsCmt()
{
	hwnd = GetCurrentWnd ()
	if(hNil == hwnd)
	{
		return;
	}
	sel = GetWndSel (hwnd)
	hbuf = GetWndBuf (hwnd)

	SetBufIns(hbuf, sel.lnFirst, sel.ichFirst);
	SetBufSelText(hbuf, "/* ");

	if(sel.lnLast > sel.lnFirst)
	{
		SetBufIns(hbuf, sel.lnLast, sel.ichLim);
		SetBufSelText(hbuf, " */");
	}
	else
	{
		SetBufIns(hbuf, sel.lnLast, sel.ichLim+3);
		SetBufSelText(hbuf, " */");
		cursor_left
		cursor_left
		cursor_left
	}
}

//clear a comment. corresponding to macro InsCmt()
macro ClrCmt()
{
	hwnd = GetCurrentWnd ()
	if(hNil == hwnd)
	{
		Msg("No active window!");
		return
	}
	sel = GetWndSel (hwnd)
	hbuf = GetWndBuf (hwnd)

	lnCnt = GetBufLineCount (hbuf)
	linelast = 0
	indexlast = 0
	
	//find " */"
	ln = sel.lnLast
	ich = sel.ichLim
	foundLast = 0;
	while(ln < lnCnt)
	{
		text = GetBufLine (hbuf, ln)
		lnWidth = strlen(text)
		while(ich < lnWidth)
		{
			if("*" == text[ich])
			{
				if("/" == text[ich + 1])
				{	//have found the " */"
					//remember the ln and ich.
					linelast = ln;
					indexlast = ich;
					foundLast = 1;

					//for break the 2 level cycle.
					ich = lnWidth;
					ln = lnCnt;
				}
			}
			else if("/" == text[ich])
			{
				if("*" == text[ich + 1])
				{
					Msg("1Can not find currect comment pair")
					return
				}
			}
			ich = ich + 1
		}
		ich = 0;
		ln = ln + 1
	}

	if(0 == foundLast)
	{
		Msg("Can not find \"*/\"");
		return
	}

	//find   " /* "
	ln = sel.lnFirst
	ich = sel.ichFirst
	text = GetBufLine (hbuf, ln)
	while(ln >= 0)
	{
		while(ich >= 0)
		{
			if("*" == text[ich])
			{
				if((ich -1) >= 0)
				{
					if("/" == text[ich - 1])
					{	//have found the  " /* "
						//del the " */ "
						SetBufIns(hbuf, linelast, indexlast)
						Delete_Character
						Delete_Character

						//del the " /* "
						SetBufIns(hbuf, ln, ich -1)
						Delete_Character
						Delete_Character

						if(ln == sel.lnFirst)
						{
							SetBufIns(hbuf, sel.lnFirst, sel.ichFirst -2)
						}
						else
						{
							SetBufIns(hbuf, sel.lnFirst, sel.ichFirst)
						}
						return
					}
				}
			}
			else if("/" == text[ich])
			{
				if((ich -1) >= 0)
				{
					if("*" == text[ich - 1])
					{
						msg("2Can not find currect comment pair")
						return
					}
				}
			}
			ich = ich - 1
		}
		ln = ln - 1
		text = GetBufLine (hbuf, ln)
		lnWidth = strlen(text)
		ich = lnWidth - 1
	}

	msg("3Can not find currect comment pair")
	return

}

