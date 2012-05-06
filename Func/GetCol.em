/*
该模块从选定的文本里截取一列.该列是按词来计算,即每一行的第1个词,每行的第二个词等.
截获的内容保存在剪切板
*/
macro GetCol()
{
	var hbufClip
	var siarg

	siarg = GetCurSiArg()
	if ( siarg.hwnd == hNil )
	{
		msg("wnd null") 
		return
	}

	hbufClip = GetBufHandle("Clipboard")
	if ( hnil == hbufClip )
	{
		msg("clip board null");
		return
	}
	ClearBuf (hbufClip)

	var sel
	sel = siarg.sel
	
	var row
	row = ask("which row to be gotten? \\ before a number will start from the end to ")

	

	var ln
	var text
	var word
	ln = sel.lnFirst 
	
	if ( row[0] == "\\" )
	{
		row = strmid(row,1,strlen(row))
		while(ln <= sel.lnLast )
		{
			text = GetBufLine (siarg.hbuf, ln)
			word = GetWordInAStringByIdxR(text,row)
			AppendBufLine(hbufClip, word)
			ln = ln + 1
		}
	}
	else
	{
		while(ln <= sel.lnLast )
		{
			text = GetBufLine (siarg.hbuf, ln)
			word = GetWordInAStringByIdx(text,row)
			AppendBufLine(hbufClip, word)
			ln = ln + 1
		}
	}
}

