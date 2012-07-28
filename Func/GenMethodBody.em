// generate the member method body
// the member member locate under the current cursor.
// the gnerated code in the clipboard.

// to do// handle comments
macro GenMethodBody()
{
	var hwnd
	hwnd = GetCurrentWnd()
	var sel
	sel = GetWndSel (hwnd)
	var hbuf;
	hbuf = GetWndBuf (hwnd)

	// clear clip board
	var hbufClip
	hbufClip = GetBufHandle("Clipboard")
	ClearBuf (hbufClip)

	var symb
	var parent
	var parentname
	var func
	var ln
	ln= sel.lnfirst;
	while(ln<=sel.lnlast)
	{
		symb = GetSymbolLocationFromLn(hbuf,ln)
		if ( nil == symb )
		{
			ln = ln + 1
			continue;
		}
		if("Method Prototype" != symb.Type)
		{
			ln = ln + 1
			continue;
		}
		func = ""
		parent = SymbolParent(symb)
		if ( parent == "" )
		{
			msg("Could not find the parent of:" #symb)
		}
		parentname = SymbolLeafName(parent)

		// get current
		var lncur
		var lncont
		var pos
		var blank
		var blanklen

		lncur = symb.lnFirst
		while(1)
		{
			lncont = GetBufLine(hbuf,lncur)
			blank = get_pre_space(lncont)
			blanklen = strlen(blank)
			
			// search for ")"
			pos = FindStr(lncont,";")
			if ( pos > 0 )
			{
				// copy all of these lines, except ";"
				lncont = strmid(lncont,blanklen,pos)
				func = cat(func,lncont)
				func = GetRideOfPrefix(func,"virtual")
				func = GetRideOfPrefix(func,"static")

				blank = get_pre_space(func)
				blanklen = strlen(blank)
				func = strmid(func,blanklen,strlen(func))
				
				func = PlusClassName(func,parentname)
				func = GetRideOfDefaultPara(func)
				AppendBufLine(hbufClip, func)
				break;
			}
			else
			{
				// if not fouund, get next line until found ";"
				lncur = lncur + 1
				lncont = strmid(lncont,blanklen,strlen(lncont))
				func = cat(func,lncont)
			}
		}
		ln=lncur

		// plus {}
		lncont = "{"
		AppendBufLine(hbufClip, lncont)
		lncont = IndentSign();
		AppendBufLine(hbufClip, lncont)
		lncont = "}"
		AppendBufLine(hbufClip, lncont)
		
		// point to next line
		ln = ln + 1
	}
}
macro PlusClassName(str,className)
{
	var pos
	pos = FindStr(str,"(")
	if ( pos < 0 )
	{
	  return str;
	}
	var tmpstr
	var info
	tmpstr = strmid(str,0,pos)
	info = GetWordInfoInAStringByIdxR(tmpstr,1)

	// check for destructor
	if ( info.position > 0 )
	{
		if ( "~" == str[info.position -1] )
		{
			info.position = info.position -1
		}
	}

	var outstr
	outstr = strmid(str,0,info.position)
	outstr = cat(outstr,className)
	outstr = cat(outstr,"::")
	tmpstr = strmid(str,info.position,strlen(str))
	outstr = cat(outstr,tmpstr)
	return outstr
}
macro GetRideOfPrefix(str,prefix)
{
	var outstr
	var pos
	var virtualstr
	virtualstr = prefix
	pos = FindStr(str,virtualstr)
	if ( pos >= 0 )
	{
		outstr = strmid(str,0,pos)
		str = strmid(str,pos+strlen(virtualstr),strlen(str))
	}
	outstr = cat(outstr,str)
	return outstr
}
macro GetRideOfDefaultPara(str)
{
	var outstr
	var pos
	var tmpstr
	while(1)
	{
		pos = FindStr(str,"=")
		if ( pos >= 0 )
		{
			tmpstr = strmid(str,0,pos)
			outstr = cat(outstr,tmpstr)
	
			str = strmid(str,pos,strlen(str))
			pos = FindOneOf(str,",)")
			if ( pos >= 0 )
			{
				str = strmid(str,pos,strlen(str))
			}
			else
			{
				break
			}
		}
		else
		{
			outstr = cat(outstr,str)
			break;
		}
	}
	return outstr
}
