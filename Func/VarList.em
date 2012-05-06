
//check if the var is a global var.
//return	0 : not a global var.
//		1 : is a global var.
macro IsGblVar(vari)
{
	len = strlen(vari);
	i = 0;
	start = 0;
	fdst = 0;	//found start char position
	while(i < len)
	{
		sts =  WhatChar(vari[i])
		if(1 == sts)
		{
			if(0 == fdst)
			{
				start = i;
				fdst = 1;
			}
		}
		else if(3 == sts)
		{
			if(1 == fdst)
			{
				fdst = 0;
				wd = strmid (vari, start, i)
				if("static" == wd)
					return 0;
			}
		}
		else if(5 == sts)
		{
			if(1 == fdst)
			{
				fdst = 0;
				wd = strmid (vari, start, i)

			/*	if("g" != wd[0])
				{
					if("G" != wd[0])
					{
						return 0;
					}
				}

				if("_" != wd[1])
					return 0;*/
			}
			return 1;
		}
		i = i + 1;
	}
	return 0;
}

//get a variable list of c file.
macro VarList()
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
		if(Symbol.type != "Variable")
		{
			continue;
		}
		cln = Symbol.lnFirst;
		Declar = GetBufLine (cbuf, cln);

		if(!IsGblVar(Declar))
		{
			continue;
		}
		startidx = 0;
		endidx = strlen(Declar)
		while(startidx<endidx)
		{
			if(Declar[startidx]=="=")
			{
				Declar = strmid(Declar,0,startidx)
				Declar = Cat(Declar,";")
				break
			}
			startidx = startidx + 1
		}
		Declar = Cat("extern ",Declar);
		Insert_Line;
		SetBufSelText(hbuf, Declar);
	}
}

