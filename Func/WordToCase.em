/*
这个模块对当前选择的文本进行扩展,把每一行的文本作为一个case,自动扩展为
case ###:
break;
的形式.但扩展后的内容会保存在剪切板里,而不会直接插入当前位置.
*/

macro EndWTC(hbufClip)
{
	AppendBufLine(hbufClip, "default:")
	AppendBufLine(hbufClip, "	break;")
	stop
}

macro WordToCase()
{
	hwnd = GetCurrentWnd ()
	if ( hnil == hwnd )
	{
		msg("wnd null");
		return
	}
	hbuf = GetWndBuf (hwnd)
	if ( hnil == hbuf )
	{
		msg("buf null");
		return
	}
	sel = GetWndSel (hwnd)

	if ( TRUE != sel.fExtended )
	{
	/*	hbufClip = GetBufHandle("Clipboard")
		if ( hnil == hbufClip )
		{
			return
		}
		else
		{
			
		}*/
		return
	}

	
	hbufClip = GetBufHandle("Clipboard")
	if ( hnil == hbufClip )
	{
		msg("clip board null");
		return
	}
	ClearBuf (hbufClip)

	ln = sel.lnFirst
	posx = sel.ichFirst

	while(1)
	{
		str = GetBufLine (hbuf, ln)
		while(1)
		{
			GWord = GetWordInAString(str,posx,1)
			if ( nil == GWord )
			{
				if ( ln == sel.lnLast )
				{
					//end
					EndWTC(hbufClip)
				}
				else
				{
					ln = ln + 1
					posx = 0
					break;
				}
			}
			else
			{
				if ( ln == sel.lnLast )
				{
					if ( GWord.position > sel.ichLim )
					{
						//end
						EndWTC(hbufClip)
					}
				}
				//got one word
				text = cat("case ",GWord.word)
				text = cat(text,":")
				AppendBufLine(hbufClip, text)
				text = "	break;"
				AppendBufLine(hbufClip, text)
				posx = GWord.position
			}
		}
	}
}

