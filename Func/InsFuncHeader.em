
//get function type. if function type is void, return "None.", else return empty string.
macro GetRetType(text,funcname)
{
	tmp = nil
	pos = 0;

	while(1)
	{
		tmp = GetWordInAString(text,pos,0)
		if(nil == tmp)
		{
			return "###";
		}
		if("void" == tmp.word)
		{
			return "None."
		}
		if("RetType" == tmp.word)
		{
			return "The status."
		}
		if(funcname == tmp.word)
		{
			return "###";
		}
		pos = tmp.position;
	}
	return "###";
}


macro SetPara(lnSym,lnPara)
{
	hbuf = GetCurrentBuf()
	ln = lnSym;

	//find "(", all para start after "("
	found = 0;
	while(1)
	{
		text = GetBufLine (hbuf, ln)
		i = 0;
		len = strlen(text)

		while(i < len)
		{
			if(text[i] == "(")
			{
				found = 1;
				break;
			}
			i = i+1
		}
		
		if(found == 1)
			break;
			
		ln = ln + 1;
	}

	//para string. the 1st time insert a para, we need to add a header "Parameter	:	"
	para = ""
	
	found = 0;

	//if found an empty char such as blank, tab, etc.. this var set to 1.
	fdempty = 0;

	//now the i pointing to "(", so parameter searching start from i + 1.
	i = i + 1;

	//if we found "/*", we must found "*/", and then we can go on the process.
	FindCloseCmt = 0;
	
	while(1)
	{
		start = i;	//a para start from var start to "," or ")"
		while(i < len)
		{
			if(0 != FindCloseCmt)	//if need find close comment.
			{
				if("*" == text[i])
				{
					i = i + 1;
					if(i < len)
					{
						if("/" == text[i])
						{
							i = i + 1
							FindCloseCmt = 0;
						}
					}
				}
				else
				{
					i = i + 1
				}
				continue;				
			}
			//if this is a comment.
			if("/" == text[i])	//is	'/'
			{
				i = i + 1;
				if(i < len)
				{
					if("/" == text[i])	//is "//", this is a right comment
					{
						found = 0;
						fdempty = 0;
						break;
					}
					if("*" == text[i])	//is "*", this is a /*  xxx */ comment
					{
						FindCloseCmt = 1;
					}
				}
			}

			sts = WhatChar(text[i])
			if(0 == sts)	//is ","
			{
				if(0 == found)
				{
					Msg("Function entity error!")
					return;
				}
				found = 0;
				para = "\@param "
				
				while(1)
				{
					sts = WhatChar(text[start])
					if((1 == sts) || (2 == sts))
					{
						para = Cat(para, text[start]);
						start = start + 1;
					}
					else
					{
						para = cat(para," : ###")
						InsBufLine(hbuf,lnPara,para)
						ln = ln + 1
						lnPara = lnPara + 1
						start = 0
						break;
					}
				}
				found = 0;
				para = "";	//para must be clear, then next time we will know that para is not the 1st para.
			}
			else if(1 == sts) //is a char can be func name.
			{
				if(0 != fdempty)
				{
					found = 1;
					start = i;
					fdempty = 0;
				}
				if(0 == found)
				{
					found = 1;
					start = i;
				}
			}
			else if(2 == sts) //is a number
			{
				if(0 != fdempty)	//numeric can not be the 1st char of variable.
				{
					msg("Argument error!");
					return;
				}
			}
			else if(4 == sts)	//is ")"
			{
				if("" == para)	//as previously mentioned.
				{
					para = "\@param "
				}
				else if(0 == found)	//if not found any para, insert string "None."
				{
					para = "Args : None."
					InsBufLine(hbuf,lnPara,para)
					return;
				}
				tmp = "";
				while(1)
				{
					sts = WhatChar(text[start])
					if((1 == sts) || (2 == sts))
					{
						tmp  = Cat(tmp, text[start]);
						start = start + 1;
					}
					else
					{
						if("void" == tmp)
						{
							para = cat(para,"None.")
						}
						else
						{
							para = cat(para,tmp)
							para = cat(para," : ###")
						}
						InsBufLine(hbuf,lnPara,para)
						break;
					}
				}
				return;
			}
			else	//is other rubbish char, such as blank, tab, or others.
			{
				fdempty = 1;
			}
			
			i = i + 1;	//point to next char.
		}
		
		ln = ln + 1;	//point to next ln
		text = GetBufLine (hbuf, ln)
		i = 0;
		len = strlen(text)
	}
}//*/
macro InsertHeader()
{
	var hwnd;
	var hbuf;
	var szFunc;
	var symb;
	var ln;
	var text;
	var ret;
	
	// Get a handle to the current file buffer and the name
	// and location of the current symbol where the cursor is.
	hwnd = GetCurrentWnd()
	if (hwnd == 0)
		stop

	hbuf = GetCurrentBuf()
	if(hnil == hbuf)
	{
		Msg("No Active Buf!")
		return
	}
	szFunc = GetCurSymbol()
	if("" == szFunc)
	{
		Msg("No Functions selected!")
		return;
	}
	symb = GetSymbolLocation (szFunc)
	if("Function" != symb.Type)
	{
		if ( "Method" != symb.Type)
		{
			msg("Not a function!");
			msg("this is a @symb.Type@");
			return;
		}
		
	}
	curfilename = getbufname(hbuf)
	if ( symb.File != curfilename )
	{
		msg("the symbol entity not in current file")
		return
	}
	ln = symb.lnFirst

	//get return type
	text = GetBufLine (hbuf, ln)
	ret = GetRetType(text,szFunc);
	ret = Cat("\@return ",ret);

	szFunc = Cat("\@fn ",szFunc)
	
	/* get data */
	time = GetDate()
	history = GetUserName()
	history = Cat(history,"	")
	history = Cat(history,time)
	history = Cat(history,"    Created")

	// insert the comment block
	InsBufLine(hbuf,ln,"")
	ln = ln+1
	InsBufLine(hbuf,ln,"/**")
	ln = ln + 1
	InsBufLine(hbuf, ln, szFunc)
	ln = ln + 1
	InsBufLine(hbuf,ln,"")
	ln = ln+1
	lnDsr = ln
	InsBufLIne(hbuf,ln,"\@brief  ###")
	ln = ln + 1
	InsBufLine(hbuf,ln,"       ")
	ln = ln + 1
//	InsBufLine(hbuf,ln,"Aurthor     : Eden.Zhong")
//	ln = ln + 1
//	InsBufLine(hbuf,ln,"")
//	ln = ln + 1
	lnPara = ln
	InsBufLine(hbuf,ln,"       ")
	ln = ln + 1
	InsBufLine(hbuf,ln,ret)
	ln = ln + 1
	InsBufLine(hbuf,ln,"       ")
	ln = ln + 1
	InsBufLine(hbuf,ln,"Log  :")
	ln = ln + 1
	InsBufLine(hbuf,ln,"<author>    <time>      <desc>")
	ln = ln + 1
	InsBufLine(hbuf, ln, history)
	ln = ln + 1
	InsBufLine(hbuf,ln,"*/")

	//insert the parameters.
	SetPara(ln + 1,lnPara);

	// put the insertion point inside the header comment
//	SetBufIns(hbuf, lnDsr, 19)
	SetBufIns(hbuf, lnDsr, 0)

//	SetWndSel(hwnd, sel)
	LoadSearchPattern("###", true, false, false);
	Search_Forward
}

