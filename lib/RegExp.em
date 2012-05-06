macro RegExp_ReplaceNword(idx)
{
	seperator = "[^a-zA-Z0-9_]+"
	word = "[a-zA-Z0-9_]+"
	str = "^\\([^a-zA-Z0-9_]*"
	i = 0
	while(i<idx)
	{
		i = i + 1
		if ( i == idx )
		{
			str = cat(str,"\\)\\(")
		}
		str = cat(str,word)
		if ( i == idx )
		{
			str = cat(str,"\\)\\(")
			str = cat(str,"\\)$")

		}
		else
		{
			str = cat(str,seperator)
		}
	}
//	str = cat(str,"\\)")
	hbuf = GetCurrentBuf ()
	SetBufSelText(hbuf,str)	
}
macro FindRegexp(text,regexp)
{
	var hbuf
	var tmpbufname
	var tmpbufidx

	tmpbufidx = 0
	while(1)
	{
		tmpbufname = cat("FindRegexp_buf",tmpbufidx)
		hbuf = GetBufHandle(tmpbufname)
		if ( hnil == hbuf )
		{
			hbuf = newbuf(tmpbufname)
			break;
		}
		tmpbufidx = tmpbufidx + 1
	}

	InsBufLine (hbuf, 0,text)

	var sel
	sel = SearchInBuf (hbuf, regexp, 0, 0, 1, 1, 0)
	closebuf(hbuf)
	return sel;
}

