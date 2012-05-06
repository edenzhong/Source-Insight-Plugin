
// .key : the config key
// .val : the config value
// .len : this config cover length of the str
macro GetConfigStr(str)
{
	var ret
	ret.key = ""
	ret.val = str
	ret.len = strlen(str)
	if ( ret.len > 1 )
	{
		if ( str[0] == "\\" )
		{
			if ( str[1] == "\\" ) // this is not a config string
			{
				ret.val = strmid(str,1,strlen(str))
				return ret
			}
			
			ret.key = str[1]
			str = strmid(str,2,strlen(str))
			pos = FindStr(str,"\\")
			if ( pos >= 0 )
			{
				ret.val = strmid(str,0,pos)
				ret.len = 2 + pos
			}
			else
			{
				ret.val = str
			}
		}
	}
	return ret
}
// .src_key : constant, clipboard, number
// .src_val : 
// .pos_key : bytes, words
// .pos_val :
macro ParseInsInfo(str)
{
	var ret;
	ret.src_key = "constant"
	ret.src_val = ""
	ret.pos_key = "b"
	ret.pos_val = 0
	ret.cont_val = ""

	var conf
	while(1)
	{
		conf = GetConfigStr(str)
		if ( conf.len == 0 )
		{
			break;
		}
		if ( conf.key == "C") // src. clipboard
		{
			ret.src_key = "clip"
		}
		else if ( conf.key == "d" ) // src. dec numbers, increase step.
		{
			ret.src_key = "dec"
			ret.src_val = StrToNum(conf.val)
		}
		else if ( conf.key == "D" ) // src. dec numbers, decrease step.
		{
			ret.src_key = "Rdec"
			ret.src_val = StrToNum(conf.val)
		}
		else if ( conf.key == "x" ) // src. hex number, increase step.
		{
			ret.src_key = "hex"
			ret.src_val = StrToNum(conf.val)
		}
		else if ( conf.key == "X" ) // src. hex number, decrease step.
		{
			ret.src_key = "Rhex"
			ret.src_val = StrToNum(conf.val)
		}
		else if (( conf.key == "b" ) // pos. near bytes
			|| (conf.key == "w" ) // pos. near words
			|| (conf.key == "W" ) // pos. near words
			|| (conf.key == "c" ) // pos. current pos
			)
		{
			ret.pos_key = conf.key
			ret.pos_val = StrToNum(conf.val)
		}
		else if (( conf.key == "e" ) // pure string
			|| (conf.key == "" )
			)
		{
			ret.cont_val = conf.val
		}
		str = strmid(str,conf.len,strlen(str))
	}
	if (( ret.src_key == "hex" ) || (ret.src_key == "Rhex" ))
	{
		ret.cont_val = NumToHexStr(ret.cont_val)
	}
		
	return ret;
}
macro StepNumber(conf,current)
{
	if ( conf.key == "dec" ) // src. dec numbers, increase step.
	{
		return current + conf.val
	}
	else if ( conf.key == "Rdec" ) // src. dec numbers, decrease step.
	{
		return current - conf.val;
	}
	else if ( conf.key == "hex" ) // src. hex number, increase step.
	{
		current = StrToNum(current)
		conf.val = StrToNum(conf.val)
		return NumToHexStr(current + conf.val)
	}
	else if ( conf.key == "Rhex" ) // src. hex number, decrease step.
	{
		current = StrToNum(current)
		conf.val = StrToNum(conf.val)
		return NumToHexStr(current - conf.val)
	}
	return "0";
}
macro InsPrefix()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	var hbuf
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	var ln
	var sz
	var insInfo
	sz = Ask("Enter the pattern.\\h for help.")
	if ( sz == "\\h")
	{
		var helpmsg
		helpmsg = "option start by a \\, a char, and a number. i.e. \\w2"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"w(num): before x words");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"W(num): after x words");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"b(num): after x chars");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"c(num): before current chars");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"C: the content comes from clip board");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"d(step): the content comes from dec num,and increase step every line.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"D(step): same as \\d, but decrease step every line.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"x(step): same as \\d, but the number is hex format.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"X(step): same as \\x, but decrease step every line.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"e(str): the string to insert. if option is d,D,x,X, this is the start number.");
		msg(helpmsg)
		return
	}
	insInfo = ParseInsInfo(sz)

	var hbufClip
	var lnLast
	lnLast = sel.lnLast
	if ( insInfo.src_key == "clip" ) 
	{
		hbufClip = GetBufHandle("Clipboard")
		var lncnt
		lncnt = sel.lnLast - sel.lnFirst + 1
		lncnt = min(lncnt,GetBufLineCount (hbufClip))
		lnLast = sel.lnFirst + lncnt - 1
	}
	else if ( insInfo.cont_val == "" )
	{
		if ( insInfo.src_key == "constant" )
		{
			return // nothing to insert
		}
		else // numbers
		{
			insInfo.cont_val = "0"
		}
	}
	if (( insInfo.pos_key == "w" ) // before word
		||( insInfo.pos_key == "W" )) // after word
	{
		ln = sel.lnFirst
		var lncont
		var signword
		var inspos
		while(ln <= lnLast)
		{
			// set the ins pos
			lncont = GetBufLine (hbuf, ln)
			signword = GetWordInfoInAStringByIdx(lncont,insInfo.pos_val)
			if ( signword != "" )
			{
				inspos = signword.position;
				if ( insInfo.pos_key == "w" ) 
				{
					inspos = inspos - strlen(signword.word);
				}
			}
			else
			{
				inspos = strlen(lncont)
			}
			SetBufIns(hbuf, ln, inspos);

			// set the ins content
			if ( insInfo.src_key == "clip" ) // clipboard
			{
				var lnclip
				var textclip
				lnclip = ln - sel.lnfirst
				textclip=GetBufLine (hbufClip, lnclip)
				insInfo.cont_val = textclip
			}
			SetBufSelText(hbuf, insInfo.cont_val)
			
			// if the src is numbers, update the number
			if (( insInfo.src_key == "dec" ) 
				|| ( insInfo.src_key == "Rdec" ) 
				|| ( insInfo.src_key == "hex" ) 
				|| ( insInfo.src_key == "Rhex" ) 
				)
			{
				var conf
				conf.key = insInfo.src_key
				conf.val = insInfo.src_val
				insInfo.cont_val = StepNumber(conf,insInfo.cont_val)
			}
			
			ln = ln + 1
		}
	}
	else
	{
		if ( insInfo.pos_key == "c" ) // insert from current position
		{
			insInfo.pos_key = "b"
			insInfo.pos_val = sel.ichfirst
		}
		if ( insInfo.pos_key != "b" ) // after char
		{
			insInfo.pos_val = 0
		}
		ln = sel.lnFirst
		while(ln <= lnLast)
		{
			// set pos
			SetBufIns(hbuf, ln, insInfo.pos_val );

			// set ins content
			if ( insInfo.src_key == "clip" )
			{
				var lnclip
				var textclip
				lnclip = ln - sel.lnfirst
				textclip=GetBufLine (hbufClip, lnclip)
				insInfo.cont_val = textclip
			}
			SetBufSelText(hbuf, insInfo.cont_val)
			
			// if the src is number, update number.
			if (( insInfo.src_key == "dec" ) 
				|| ( insInfo.src_key == "Rdec" ) 
				|| ( insInfo.src_key == "hex" ) 
				|| ( insInfo.src_key == "Rhex" ) 
				)
			{
				var conf
				conf.key = insInfo.src_key
				conf.val = insInfo.src_val
				insInfo.cont_val = StepNumber(conf,insInfo.cont_val)
			}

			ln = ln + 1
		}
	}
	sel.ichFirst = 0;
	sz = getbufline(hbuf,sel.lnlast)
	sel.ichLim = strlen(sz)
	SetWndSel(hwnd,sel)
}
macro InsSuffix()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	var hbuf;
	var insInfo;
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	sz = Ask("Enter the pattern.\\h for help.")
	if ( sz == "\\h")
	{
		var helpmsg
		helpmsg = "option start by a \\, a char, and a number. i.e. \\w2"
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"w(num): before x words");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"W(num): after x words");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"b(num): before x chars");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"c(num): before current chars");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"C: the content comes from clip board");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"d(step): the content comes from dec num,and increase step every line.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"D(step): same as \\d, but decrease step every line.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"x(step): same as \\d, but the number is hex format.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"X(step): same as \\x, but decrease step every line.");
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"e(str): the string to insert. if option is d,D,x,X, this is the start number.");
		msg(helpmsg)
		return
	}
	insInfo = ParseInsInfo(sz)

	var hbufClip
	var lnLast
	lnLast = sel.lnLast
	if ( insInfo.src_key == "clip" )
	{
		hbufClip = GetBufHandle("Clipboard")
		var lncnt
		lncnt = sel.lnLast - sel.lnFirst + 1
		lncnt = min(lncnt,GetBufLineCount (hbufClip))
		lnLast = sel.lnFirst + lncnt - 1
	}
	else if ( insInfo.cont_val == "" )
	{
		if ( insInfo.src_key == "constant" )
		{
			return // nothing to insert
		}
		else // numbers
		{
			insInfo.cont_val = "0"
		}
	}
	var ln
	if (( insInfo.pos_key == "w" ) // before word
		|| ( insInfo.pos_key == "W" )) // after word
	{
		ln = sel.lnFirst
		var lncont
		var signword
		var inspos
		while(ln <= lnLast)
		{
			// set the ins pos
			lncont = GetBufLine (hbuf, ln)
			signword = GetWordInfoInAStringByIdxR(lncont,insInfo.pos_val)
			if ( signword != "" )
			{
				inspos = signword.position
				if ( insInfo.pos_key == "W" )
				{
					inspos = inspos + strlen(signword.word)
				}
			}
			else
			{
				inspos = 0
			}
			SetBufIns(hbuf, ln, inspos);

			// set the ins content
			if ( insInfo.src_key == "clip" )
			{
				var lnclip
				var textclip
				lnclip = ln - sel.lnfirst
				textclip=GetBufLine (hbufClip, lnclip)
				insInfo.cont_val = textclip
			}
			SetBufSelText(hbuf, insInfo.cont_val)
			
			// if the src is numbers, update the number
			if (( insInfo.src_key == "dec" ) 
				|| ( insInfo.src_key == "Rdec" ) 
				|| ( insInfo.src_key == "hex" ) 
				|| ( insInfo.src_key == "Rhex" ) 
				)
			{
				var conf
				conf.key = insInfo.src_key
				conf.val = insInfo.src_val
				insInfo.cont_val = StepNumber(conf,insInfo.cont_val)
			}
			
			ln = ln + 1
		}
	}
	else
	{
		if ( insInfo.pos_key == "c" ) // insert from current position
		{
			insInfo.pos_key = "b"
			insInfo.pos_val = sel.ichfirst
			if ( sel.ichfirst > 0 ) // before the select char
			{
				insInfo.pos_val = insInfo.pos_val + 1
			}
		}
		var inspos
		ln = sel.lnFirst
		while(ln <= lnLast)
		{
			var lnlen
			var lncont

			// set ins pos
			lncont = GetBufLine (hbuf, ln)
			lnlen = strlen(lncont)
			if ( insInfo.pos_key != "b" )
			{
				inspos = lnlen
			}
			else
			{
				if ( insInfo.pos_val > lnlen )
				{
					inspos = 0
				}
				else
				{
					inspos = lnlen - insInfo.pos_val
				}
			}
			SetBufIns(hbuf, ln, inspos);
			
			// set ins content
			if ( insInfo.src_key == "clip" )
			{
				var lnclip
				var textclip
				lnclip = ln - sel.lnfirst
				textclip=GetBufLine (hbufClip, lnclip)
				insInfo.cont_val = textclip
			}
			SetBufSelText(hbuf, insInfo.cont_val)

			// if the src is number, update number.
			if (( insInfo.src_key == "dec" ) 
				|| ( insInfo.src_key == "Rdec" ) 
				|| ( insInfo.src_key == "hex" ) 
				|| ( insInfo.src_key == "Rhex" ) 
				)
			{
				var conf
				conf.key = insInfo.src_key
				conf.val = insInfo.src_val
				insInfo.cont_val = StepNumber(conf,insInfo.cont_val)
			}

			ln = ln + 1
		}
	}
	sel.ichFirst = 0;
	sz = getbufline(hbuf,sel.lnlast)
	sel.ichLim = strlen(sz)
	SetWndSel(hwnd,sel)
}
macro ClrSuffix()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	sz = Ask("Enter the suffix. \\h for help")
	if ( sz == "\\h" )
	{
		var helpmsg
		helpmsg = "1)str: find str and del."
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"2)\\x: clear x chars")
		msg(helpmsg)
		return ;
	}
	if (sz != "")
	{
		szlen = strlen(sz)
		
		if ( sz[0] == "\\" )
		{
			sz = strmid (sz, 1, szlen) //del the 1st '\'
			szlen = szlen - 1
			
			if ( sz[0] != "\\" )
			{
				//to get cnt
				idx = 1
				while(idx < szlen)
				{
					if ( 2 != WhatChar(sz[idx]) ) //not a number
					{
						return
					}
					idx = idx + 1
				}
				ln = sel.lnFirst
				while( ln <= sel.lnLast )
				{
					text = GetBufLine(hbuf,ln)
					tlen = strlen(text)
					
					if ( tlen >= szlen )
					{
						text = strmid(text,0,tlen-sz)
						DelBufLine(hbuf,ln)
						InsBufLine (hbuf, ln, text)
					}
					ln = ln + 1
				}
				return
			}
		}
		ln = sel.lnFirst
		while( ln <= sel.lnLast )
		{
			text = GetBufLine(hbuf,ln)
			tlen = strlen(text)
			//msg("test:@text@,tlen:@tlen@")
			if ( tlen >= szlen )
			{
				str = strmid(text,tlen-szlen,tlen)
				//msg("str:@str@")
				if ( str == sz )
				{
					str = strmid(text,0,tlen-szlen);
					DelBufLine(hbuf,ln)
					InsBufLine (hbuf, ln, str)
				}
			}
			ln = ln + 1
		}
	}
}

macro ClrPrefix()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	sz = Ask("Enter the prefix. \\h for help")
	if ( sz == "\\h" )
	{
		var helpmsg
		helpmsg = "1)str: find str and del."
		helpmsg = cat(helpmsg,chEnter())
		helpmsg = cat(helpmsg,"2)\\x: clear x chars")
		msg(helpmsg)
		return ;
	}

	if (sz != "")
	{
		szlen = strlen(sz)
		
		if ( sz[0] == "\\" )
		{
			sz = strmid (sz, 1, szlen) //del the 1st '\'
			szlen = szlen - 1
			
			if ( sz[0] != "\\" )
			{
				//to get cnt
				idx = 0
				while(idx < szlen)
				{
					if ( 2 != WhatChar(sz[idx]) ) //not a number
					{
						return
					}
					idx = idx + 1
				}
				ln = sel.lnFirst
				while( ln <= sel.lnLast )
				{
					text = GetBufLine(hbuf,ln)
					tlen = strlen(text)
					
					if ( tlen >= szlen )
					{
						text = strmid(text,sz,tlen)
						DelBufLine(hbuf,ln)
						InsBufLine (hbuf, ln, text)
					}
					ln = ln + 1
				}
				return
			}
		}
		ln = sel.lnFirst
		while( ln <= sel.lnLast )
		{
			text = GetBufLine(hbuf,ln)
			tlen = strlen(text)
			if ( tlen >= szlen )
			{
				str = strmid(text,0,szlen)
				if ( str == sz )
				{
					str = strmid(text,szlen,tlen);
					DelBufLine(hbuf,ln)
					InsBufLine (hbuf, ln, str)
				}
			}
			ln = ln + 1
		}
	}
}

