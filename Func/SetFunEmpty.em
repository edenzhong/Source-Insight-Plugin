





// lnSym org arg start ln
// lnPara cont start ln
macro SetEmptyFuncPara(lnSym,lnPara)
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

	//para string.
	para = ""
	
	found = 0;

	//if found an empty char such as blank, tab, etc.. this var set to 1.
	fdempty = 0;

	//now the i pointing to "(", so parameter searching start from i + 1.
	i = i + 1;

	//if we found "/*", we must found "*/", and then we can go on the process.
	FindCloseCmt = 0;

	// if the var is a const, no need to proc.
	isConstVar = 0;
	
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

				if ( 0 == isConstVar )
				{
					para = ""
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
							tmpstr = para;
							para = cat(para," = ")
							para = cat(para,tmpstr)
							para = cat(para,";");
							para = cat("	",para)
							InsBufLine(hbuf,lnPara,para)
							ln = ln + 1
							lnPara = lnPara + 1
							start = 0
							break;
						}
					}
					found = 0;
					para = "";
				}
				else
				{
					isConstVar = 0;
				}
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
				if ( isConstVar )
				{
					return;
				}
				para = ""
				if(0 == found)	//if not found any para, insert string "None."
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
						if("void" != tmp)
						{
							para = cat(para,tmp)
							para = cat(para,"  = ")
							para = cat(para,tmp)
							para = cat(para,";")
							para = cat("	",para)
							InsBufLine(hbuf,lnPara,para)
						}
						
						break;
					}
				}
				return;
			}
			else	//is other rubbish char, such as blank, tab, or others.
			{
				fdempty = 1;
				if ( found != 0 )
				{
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
							if ( "const" == para )
							{
								isConstVar = 1;
							}
							break;
						}
					}
				}
				para = "";
			}
			
			i = i + 1;	//point to next char.
		}
		
		ln = ln + 1;	//point to next ln
		text = GetBufLine (hbuf, ln)
		i = 0;
		len = strlen(text)
	}
}//*/

macro SetFunEmpty()
{
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
	ln = symb.lnFirst

	//get return type
	text = GetBufLine (hbuf, ln)
	retv	= GetWordInAString(text,0,0);
	ret = "	"
	if ( retv.word != "void" )
	{
		if ( retv.position != symb.ichName )
		{
			rettp = strmid(text,0,symb.ichName)
			ret = cat("	return *((",rettp)
			ret = cat(ret,"*)0);");
		}
	}
	ln = ln +1
	InsBufLine(hbuf,ln,"}");
	InsBufLine(hbuf,ln,ret);
	InsBufLine(hbuf,ln,"{");
	

	
	
	SetEmptyFuncPara(symb.lnFirst,ln+1);
	
}

