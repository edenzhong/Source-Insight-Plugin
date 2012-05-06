// delete all lines in the buffer
macro EmptyBuf(hbuf)
{
	lnMax = GetBufLineCount(hbuf)
	while (lnMax > 0)
		{
		DelBufLine(hbuf, 0)
		lnMax = lnMax - 1
		}
}


macro AppendBuf(hbuf,itext)
{
	if ( hnil == hbuf )
	{
		return
	}
	text = itext
	lncnt = GetBufLineCount(hbuf)
	if ( lncnt > 0 )
	{
		ln = lncnt - 1
	}
	else
	{
		ln = 0
		AppendBufLine(hbuf,"")
	}
	
	str = GetBufLine (hbuf, ln)
	text = cat(str,text)
	DelBufLine (hbuf, ln)

	while(1)
	{
		LnStr = GetLineOfStr(text)
		if ( nil == LnStr )
		{
			//end
			return
		}
		else
		{
			AppendBufLine (hbuf, LnStr.str)
			text = strmid(text,LnStr.pos,strlen(text))
		}
	}
}
