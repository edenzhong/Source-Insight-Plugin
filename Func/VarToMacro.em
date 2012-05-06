
macro VarToMacro()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	ln = sel.lnFirst 
	CapA = AsciiFromChar ("A")
	CapZ = AsciiFromChar ("Z")
	Lita = AsciiFromChar ("a")
	Litz = AsciiFromChar ("z")
	AscLine = AsciiFromChar ("_")
	AscLineAct = 0
	
	while( ln <= sel.lnLast)
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
			contval = AsciiFromChar(cont[idx])
			if( contval >= CapA && contval <= CapZ )
			{
				if((idx>0) && (AscLineAct==0))
				{
					tmp = cat(tmp,"_")
				}
				tmp = cat(tmp,cont[idx])
			}
			else if(contval >=Lita && contval <= Litz)
			{
				ch = contval - Lita
				ch = ch + CapA
				ch = CharFromAscii(ch)
				tmp = cat(tmp,ch)
			}
			else
			{
				tmp = cat(tmp,cont[idx])
			}
			idx = idx + 1

			if(AscLine == contval )
			{
				AscLineAct = 1
			}
			else
			{
				AscLineAct = 0
			}
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

