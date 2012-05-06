
//check if the func is a global func.
//return	0 : not a global func.
//		1 : is a global func.
macro IsGblFunc(func)
{
	len = strlen(func);
	i = 0;
	start = 0;
	fdst = 0;	//found start char position
	while(i < len)
	{
		sts =  WhatChar(func[i])
		if(1 == sts)
		{
			if(0 == fdst)
			{
				start = i;
				fdst = 1;
			}
		}
		//else if(3 == sts)
		else if(2 != sts)
		{
			if(1 == fdst)
			{
				fdst = 0;
				wd = strmid (func, start, i)
				if("static" == wd)
					return 0;
			}
		}
		else if(6 == sts)
			break;
		i = i + 1
	}
	return 1;
}

//get the ')' line of a function, if gotten, retern the line which the ')' in.
macro FindFuncEnd(hbuf,ln)
{
	ret = nil 
	ret.line = ln;
	ret.pos = 0;
	FindCloseCmt = 0;
	while(1)
	{
		text = GetBufLine (hbuf, ln);
		len = strlen(text)
		i = 0;
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
					sts = WhatChar(text[i]);
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

			
			if(")" == text[i])
			{
				ret.line = ln;
				ret.pos = i;
				return ret;
			}
			i = i + 1;
		}
		ln = ln + 1;
	}
}

//get a function list of a c file
macro FuncList()
{
	hbuf = GetCurrentBuf();
	/* get file name */
	FileName = GetBufName (hbuf)
	FileName = GetFileNameFromFullPath(FileName)


	len = strlen(FileName)
	len = len - 1;
	if(FileName[len] != "h")
	{
		Msg("This is NOT a header file!");
		return;
	}

	FileName[len] = "c";
	cbuf = OpenBuf (FileName)
	if(cbuf == hNil)
	{
		Msg("Can not find an appropriate c file!");
		return;
	}

	SymCnt = GetBufSymCount(cbuf)
	

	SymIndex = 0;
	Symbol = 0;
	Declar = 0;

	while(SymIndex < SymCnt)
	{
		Symbol = GetBufSymLocation(cbuf, SymIndex)
		SymIndex = SymIndex + 1;
		if(Symbol.type != "Function")
		{
			continue;
		}
		cln = Symbol.lnFirst;
		Declar = GetBufLine (cbuf, cln);
		if(!IsGblFunc(Declar))
		{
			continue;
		}

		Declar = Cat("extern ",Declar);
		FuncEnd = FindFuncEnd(cbuf,cln);
		endln = FuncEnd.line
		while(1)
		{
			cln = cln + 1;
			if(cln > endln)
			{
				if(endln == Symbol.lnFirst)
				{
				FuncEnd.pos = FuncEnd.pos + 8	//len of "extern " == 7, the additional "1" is set for ";"
				}
				else
				{
					FuncEnd.pos = FuncEnd.pos + 1
				}

				//here for the comment after the func
				tmp = strmid(Declar,0,FuncEnd.pos)
				tmp = Cat(tmp,";")
				tmplen = strlen(Declar)
				tmplen = tmplen
				tmp1 = strmid(Declar,FuncEnd.pos,tmplen)
				Declar = Cat(tmp,tmp1)
				
				Insert_Line;
				SetBufSelText(hbuf, Declar);
				break;
			}
			
			Insert_Line;
			SetBufSelText(hbuf, Declar);
			Cursor_Down
			Declar = GetBufLine (cbuf, cln);			
		}

	}
}

