/*
该模块把一段代码包裹在一对大括号内.这对大括号将会分别在
这段代码的前后各增加一行,单独放置该大括号
*/
macro set_blk_parenthesis()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	indent = ""
	//find the indent of 1st line,
	idx = 0
	text = getbufline(hbuf,sel.lnfirst)
	len = strlen(text)
	while(idx < len)
	{
		if ( ( " " != text[idx] ) && ( "	" != text[idx] ) )
		{
			indent = strmid(text,0,idx)
			break;
		}
		idx = idx + 1
	}

	needindent = 1
	//check if need indent content
	if ( sel.lnfirst > 1 )
	{
		indent1=""
		idx1=0
		text1=getbufline(hbuf,sel.lnfirst-1)
		len1=strlen(text1)
		while(idx1<len1)
		{
			if ( ( " " != text1[idx1] ) && ( "	" != text1[idx1] ) )
			{
				indent1 = strmid(text1,0,idx1)
				idntlen1 = strlen(indent1)
				idntlen=strlen(indent)
				//msg("idntlen1:@idntlen1@,idntlen:@idntlen@")
				if ( idntlen1 + 1 == idntlen )
				{
					//msg("no need indent")
					needindent = 0
				}/*
				else
				{
					msg("need indent")
					needindent=1
				}*/
				break;
			}
			idx1 = idx1 + 1
		}
	}

	if ( needindent )
	{
		//indent the content
		ln = sel.lnfirst
		while(ln <= sel.lnlast)
		{
			text = getbufline(hbuf,ln)
			text = cat("	",text)
			delbufline(hbuf,ln)
			insbufline(hbuf,ln,text)
			ln = ln + 1
		}
	}
	else
	{
		//no need indent
		idntlen=strlen(indent)
		if ( idntlen > 0 )
		{
			if ( ( " " == indent[idntlen-1] ) || ("	" == indent[idntlen-1]) )
			{
				indent = strmid(indent,0,idntlen-1);
			}
		}
	}
	
	//add parenthesis to end
	text = cat(indent,"}");
	insbufline(hbuf,sel.lnLast+1,text)

	//add parenthesis to start
	text = cat(indent,"{")
	insbufline(hbuf,sel.lnfirst,text)

	//select whole parenthesis
	SetBufIns (hbuf, sel.lnfirst+1, 0)
	Select_Block 
}


