
macro GetClpBrdNum(char)
{
	var ClpBrd
//	if ( char >= 0 )
	{
//		if ( char <= 9 )
		{
			ClpBrd = "ClpBrd1"
			ClpBrd=cat("ClpBrd",char)
			return ClpBrd
		}
	}
//	return nil
}

macro mul_paste()
{
	hwnd=GetCurrentWnd ()
	if ( hnil == hwnd )
	{
		msg("no act wnd");
		return
	}
	hbuf=GetWndBuf (hwnd)

	key = GetKey()
	char = CharFromKey(key)
	ClpBrd=GetClpBrdNum(char)
	if ( nil == ClpBrd )
	{
		return
	}

	text = GetEnv (ClpBrd)
	LnStr = GetLineOfStr(text)
	if ( nil == LnStr )
	{
		return
	}
	
	sel=GetWndSel (hwnd)
	if ( sel.fExtended )
	{
		Backspace
	}

	tmptext=GetBufLine (hbuf, sel.lnFirst)
	//get the content after sel in the same line.
	BaseLnCtx=tmptext
	BaseCtxLen = strlen(BaseLnCtx)
	if ( BaseCtxLen > sel.ichFirst )
	{
		BaseLnCtx=strmid(BaseLnCtx,sel.ichFirst,BaseCtxLen);

		//clear the content after sel in the same line
		tmptext=strmid(tmptext,0,sel.ichFirst)
		DelBufLine (hbuf, sel.lnFirst)
		InsBufLine (hbuf, sel.lnFirst,tmptext)
		SetBufIns (hbuf, sel.lnFirst, sel.ichFirst)
	}
	else
	{
		BaseLnCtx=nil;
	}

	

	//add 1st line of clpbrd to the cur pos
	SetBufSelText(hbuf,LnStr.str)
	text = strmid(text,LnStr.pos,strlen(text))

	
	ln = sel.lnFirst
	//msg("ln:@ln@")
	while(1)
	{
		LnStr = GetLineOfStr(text)
		if ( nil == LnStr )
		{
			//end
			SetBufIns (hbuf, ln, 0)
			end_of_line
			if ( BaseLnCtx != nil )
			{
				sel=GetWndSel (hwnd)
				SetBufSelText(hbuf,BaseLnCtx)
				SetBufIns (hbuf, sel.lnFirst, sel.ichFirst)
			}
			return
		}
		else
		{
			ln = ln + 1
			InsBufLine (hbuf, ln, LnStr.str)
			text = strmid(text,LnStr.pos,strlen(text))
		}
		//msg("ln @ln@")
	}
}
macro mul_copy()
{
	hwnd=GetCurrentWnd ()
	if ( hnil == hwnd )
	{
		msg("no act wnd");
		return
	}
	hbuf=GetWndBuf (hwnd)

	key = GetKey()
	char = CharFromKey(key)
	ClpBrd=GetClpBrdNum(char)
	if ( nil == ClpBrd )
	{
		return
	}

	sel=GetWndSel (hwnd)
	envval=""
	ent=chEnter()
	if ( sel.fExtended )
	{
		ln = sel.lnFirst

		while(ln <= sel.lnLast )
		{
			text = GetBufLine (hbuf, ln)

			if ( ln == sel.lnFirst )
			{
				chFirst = sel.ichFirst
			}
			else
			{
				chFirst = 0
			}
			if ( ln == sel.lnLast )
			{
				chLim = sel.ichLim
			}
			else
			{
				chLim = strlen(text)
			}
			str = strmid(text,chFirst,chLim)
			envval=cat(envval,str)
			if ( ln != sel.lnLast )
			{
				envval=cat(envval,ent)
			}
			ln = ln + 1
		}
		PutEnv (ClpBrd, envval)
	}
}


