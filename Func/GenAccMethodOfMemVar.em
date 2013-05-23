// generate the source code of Set/Get a member variable.
// the member variable locate under the current cursor.
// the gnerated code in the clipboard.
macro GenAccMethodOfMemVar()
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

	var ln
	ln= sel.lnfirst;
	while(ln<=sel.lnlast)
	{
		// get line.
		var cont
		cont = GetBufLine(hbuf, ln)
	
		// get last word as the var name
		var memvar
		memvar = GetWordInAStringByIdxR(cont,1) 
		var purevarname
		purevarname = memvar
		var varlen
		varlen = strlen(memvar)
		if ( varlen>1)
		{
//			if (( memvar[0] == "m" ) && (memvar[1] == "_" ))
//			{
//				purevarname = strmid(memvar,2,strlen(memvar))
//			}
			
			if ( memvar[varlen-1] == "_" )
			{
				purevarname = strmid(memvar,0,varlen -1)
			}
		}
		//purevarname[0] = toupper(purevarname[0])
		
		
		// get rest as the type name
		var pos
		pos = FindStrR(cont,memvar)
		var blanklen
		var blank
		blank = get_pre_space(cont)
		blanklen = strlen(blank)
	
		var typename
		typename = strmid(cont,blanklen,pos)
		
		
		// gen public: inline void Setxxx
		var SetMethod
		SetMethod = cat("inline void set_" ,purevarname)
		SetMethod = cat(SetMethod,"(")
		SetMethod = cat(SetMethod,typename)
		SetMethod = cat(SetMethod," val){")
		SetMethod = cat(SetMethod,memvar)
		SetMethod = cat(SetMethod,"=val;}")
		AppendBufLine(hbufClip, SetMethod)
	
		// gen public: inline T Getxxx
		var GetMethod
		GetMethod = cat("inline ",typename)
		GetMethod = cat(GetMethod," get")
		GetMethod = cat(GetMethod,purevarname)
		GetMethod = cat(GetMethod,"()const{return ")
		GetMethod = cat(GetMethod,memvar)
		GetMethod = cat(GetMethod,";}")
		AppendBufLine(hbufClip, GetMethod)

		ln = ln + 1
	}
}

