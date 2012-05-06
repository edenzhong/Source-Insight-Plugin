/*
删除一个选定块前后的括号,可以删除大括号和小括号
*/
// 测试字符srcch是否等于chars里的任意一个
// 是则返回1 否则返回0
macro IsInclude(srcch,chars)
{
	len = strlen(chars)
	idx=0
	while(idx<len)
	{
		if( srcch==chars[idx])
		{
			return 1
		}
		idx=idx+1
	}
	return 0
}
// 测试一个区域的第一个字符和最后一个字符是否是指定字符
// 是则返回1 否则返回0
macro CheckHeadTail(head,tail)
{
	hwnd = GetCurrentWnd()
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)
	if( sel.fExtended )
	{
		text=getbufline(hbuf,sel.lnfirst)
		
		len=strlen(text)
		if( len>sel.ichFirst )
		{
			len=sel.ichFirst
		}
		if(head == text[len])
		{
			if(sel.ichLim>0)
			{
				text=getbufline(hbuf,sel.lnlast)
				len=strlen(text)
				if( len>sel.ichlim )
				{
					len=sel.ichlim
				}
				if(tail==text[len - 1])
				{
					return 1
				}
			}
		}
	}
	return 0
}
macro GetIndent(str)
{
	len = strlen(str)
	idx = 0
	while(idx<len)
	{
		if(0==IsInclude(str[idx]," 	"))
		{
			break;
		}
		idx=idx+1
	}
	if( idx>0)
	{
		text=strmid(str,0,idx);
	}
	else
	{
		text = ""
	}
	return text
}
macro Islastlnempty(text)
{
	len=strlen(text)
	idx=0
	found = 0
	while(idx<len)
	{
		if(0==IsInclude(text[idx],"	 ") 
		{
			if( text[idx]=="}")
			{
				if(found>0)
				{
					// not empty line
					return 0;
				}
				else
				{
					found = 1
				}
			}
			else
			{
				return 0
			}
		}
		idx=idx+1
	}
	return 1
}
macro Isfirstlnempty(text.ChHead)
{
	len=strlen(text)
	idx=0
	found = 0
	while(idx<len)
	{
		if(0==IsInclude(text[idx],"	 ") 
		{
			if( text[idx]==ChHead)
			{
				if(found>0)
				{
					// not empty line
					return 0
				}
				else
				{
					found = 1
				}
			}
			else
			{
				return 0
			}
		}
		idx=idx+1
	}
	return 1;
}
macro DelParenthesis()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)
	var ChHead;
	var ChTail;

	ChHead = 0;

	if(CheckHeadTail("{","}"))
	{
		ChHead = "{";
		ChTail = "}";
	}
	else
	{
		if(CheckHeadTail("(",")"))
		{
			ChHead = "(";
			ChTail = ")";
		}
	}
	if(0 != ChHead)
	{
		// indent in the content
		if( sel.lnlast>sel.lnfirst+1)
		{
			text=getbufline(hbuf,sel.lnfirst)
			indent = GetIndent(text)
			text=getbufline(hbuf,sel.lnfirst+1)
			idtcont = GetIndent(text)

			if( strlen(indent)<strlen(idtcont) )
			{
				tsel=sel
				tsel.lnfirst=sel.lnfirst+1
				tsel.lnlast=sel.lnlast-1
				tsel.ichfirst=0
				tsel.ichlim=1
				SetWndSel (hwnd, tsel)
				Indent_Left
			}
		}


		// del tail
		text=getbufline(hbuf,sel.lnlast)
		if( Islastlnempty(text) )
		{
			delbufline(hbuf,sel.lnlast)
			if(sel.lnlast>0)
			{
				sel.lnlast=sel.lnlast-1
			}
			text=getbufline(hbuf,sel.lnlast)
			sel.ichlim=strlen(text)
		}
		else
		{
			//idx=FindStr(text,ChTail)
			idx = sel.ichLim - 1
			if( idx>= 0)
			{
				text[idx]=" "
				delbufline(hbuf,sel.lnlast)
				insbufline(hbuf,sel.lnlast,text)
			}
		}

		// del head
		text=getbufline(hbuf,sel.lnfirst)
		if( Isfirstlnempty(text,ChHead) )
		{
			delbufline(hbuf,sel.lnfirst)
			if(sel.lnlast>0)
			{
				sel.lnlast=sel.lnlast-1
			}
			sel.ichfirst = 0
		}
		else
		{
			//idx=FindStr(text,ChHead)
			idx = sel.ichFirst 
			//if( idx>= 0)
			{
				text[idx]=" "
				delbufline(hbuf,sel.lnfirst)
				insbufline(hbuf,sel.lnfirst,text)
			}
		}

		// set buf sel
		setwndsel(hwnd,sel)
	}
}

