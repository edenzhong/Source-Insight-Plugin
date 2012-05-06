
macro StrToAry()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)
	ln = sel.lnFirst 
	while(ln <= sel.lnLast)
	{
		tmp = getbufline(hbuf,ln)
		if( ln == sel.lnFirst )
		{
			start = sel.ichFirst;
		}
		else
		{
			start = 0
		}
		if(ln == sel.lnLast)
		{
			lim = sel.ichLim
		}
		else
		{
			lim = strlen(tmp)
		}

		cont = strmid(tmp,start,lim)
		tmp = "";
		idx = 0;
		len = strlen(cont)
		while(idx<len)
		{
			tmp = cat(tmp,"'")
			tmp = cat(tmp,cont[idx])
			tmp = cat(tmp,"',")
			idx = idx + 1
		}
		cont = getbufline(hbuf,ln)
		head = strmid(cont,0,start)
		tail = strmid(cont,lim,strlen(cont))
		delbufline(hbuf,ln)
		cont = cat(head,tmp)
		cont = cat(cont,tail)
		insbufline(hbuf,ln,cont)
		ln = ln + 1
	}
}

