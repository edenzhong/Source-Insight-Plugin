macro func_indent_selection()
{
	// get selection
	var hwnd
	hwnd = GetCurrentWnd()
	if (hnil == hwnd)
	{
		return;
	}

	var hbuf
	hbuf = GetCurrentBuf()

	var sel
	sel = GetWndSel(hwnd)
	
	// get the indent of last non-empty line
	var ln
	var str
	var pos
	var baseidt
	var plusidt
	
	baseidt = ""
	plusidt = IndentSign()
	ln = sel.lnfirst;
	if ( ln > 0 )
	{
		ln = ln - 1 // point to last line
		while ( ln>= 0 )
		{
			str = getbufline(hbuf,ln)
			pos = FindNotOf(str," 	")
			if ( pos >= 0 )
			{
				baseidt = strmid(str,0,pos)
				str = purge_string(str)
				var len
				len = strlen(str)
				var ch
				ch = str[len-1] // len must > 0, because we found a ch != space and tab
				if (( ":" == ch ) || ("{" == ch ))
				{
					baseidt = cat(baseidt,plusidt) 
				}
				else if ( ("}" == ch ))
				{
					var baselen
					baselen = strlen(baseidt)
					var pluslen
					pluslen = strlen(pluslen)
					if ( baselen > pluslen )
					{
						baseidt = strmid(baseidt,0,baselen-pluslen)
					}
					else
					{
						baseidt = ""
					}
				}
				break
			}
			ln = ln - 1
		}
	}
	
	len = strlen(baseidt)

	var newstr
	var opencnt
	// loop 
	ln = sel.lnfirst
	while( ln <= sel.lnlast)
	{
		// indent current line.
		str = getbufline(hbuf,ln)
		str = purge_string(str)
		if ( is_close_char(str[0]) )
		{
			var tmpidt
			var adjutment
			adjutment = -1
			tmpidt = adjust_indent(baseidt,adjutment,plusidt) 
			newstr = cat(tmpidt,str)
		}
		else
		{
			newstr = cat(baseidt,str)
		}
		
		putbufline(hbuf,ln,newstr)
		ln = ln + 1

		// prepare new indent
		opencnt = count_open(str);
		baseidt = adjust_indent(baseidt,opencnt,plusidt) 
	}
}
macro adjust_indent(str,adjustment,plusidt)
{
	if ( adjustment > 0 )
	{
		while(adjustment>0)
		{
			str = cat(str,plusidt)
			adjustment = adjustment - 1
		}
	}
	else if ( adjustment < 0 )
	{
		var idtlen
		idtlen = strlen(plusidt)
		var pos
		while(adjustment<0)
		{
			pos = FindStr(str,plusidt)
			if ( pos == 0 )
			{
				str = strmid(str,idtlen,strlen(str))
			}
			else
			{
				break
			}
			adjustment = adjustment + 1
		}
	}
	return str;
}
macro is_open_char(ch)
{
	if ( "(" == ch ){return 1;}
	if ( "{" == ch ){return 1;}
	return 0;
}

macro is_close_char(ch)
{
	if ( ")" == ch ){return 1;}
	if ( "}" == ch ){return 1;}
	return 0;
}
macro count_open(str)
{
	var opencnt
	opencnt = 0
	var len
	len = strlen(str)
	var i
	i = 0
	while (i < len)
	{
		if ( is_open_char(str[i] ))
		{
			opencnt = opencnt + 1
		}
		else if ( is_close_char(str[i]) )
		{
			opencnt = opencnt - 1
		}
		// to do // process "" and comment
		i = i + 1
	}
	return opencnt;
}
