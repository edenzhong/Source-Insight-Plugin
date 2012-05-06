
macro GenClassUMLDesc()
{
	var symbolname
	var symbol
	var hsyml
	var cchild
	var ichild
	var childsym
	
	symbolname = GetCurSymbol ()
	symbol = GetSymbolLocation(symbolname)
	if (symbol == nil)
	{
		Msg (symbolname # " was not found")
	}
	else
	{
		if ( "Class" == symbol.Type )
		{
			// create a tmp buf
			var bufname
			var hbuf
			var ln
			var tmpname
			var tmppos
			
			bufname = cat("UMLClass_buf",bufname)
			hbuf = GetBufHandle (bufname)
			if ( hnil == hbuf )
			{
				hbuf = newbuf(bufname)
			}
			else
			{
				clearbuf(hbuf)
			}

			// insert class name
			tmppos = findstrR(symbol.symbol,".")
			if ( tmppos >= 0 )
			{
				tmpname = strmid(symbol.symbol,tmppos+1,strlen(symbol.symbol))
			}
			else
			{
				tmpname = symbol.symbol
			}
			InsBufLine (hbuf, 0, "\\B" # tmpname # "\\b\\_")
			
			ln = 1
			hsyml = SymbolChildren(symbol)
			cchild = SymListCount(hsyml)
			
			// loop to find member variables and insert to buf
			ichild = 0
			while (ichild < cchild)
			{
				childsym = SymListItem(hsyml, ichild)
				if ( findstr(childsym.type,"Member" ) >= 0 )
				{
					tmppos = findstrR(childsym.symbol,".")
					//msg("tmppos:@tmppos@")
					if ( tmppos >= 0 )
					{
						tmpname = strmid(childsym.symbol,tmppos+1,strlen(childsym.symbol))
					}
					else
					{
						tmpname = childsym.symbol
					}
					InsBufLine (hbuf, ln, tmpname )
					ln = ln + 1
				}
				ichild = ichild + 1
			}
			insbufline(hbuf,ln, "\\_")
			ln = ln + 1
			
			// loop to find member methods and insrt to buf
			ichild = 0
			while (ichild < cchild)
			{
				childsym = SymListItem(hsyml, ichild)
				if ( findstr(childsym.type,"Method" ) >= 0 )
				{
					tmppos = findstrR(childsym.symbol,".")
					//msg("tmppos:@tmppos@")
					if ( tmppos >= 0 )
					{
						tmpname = strmid(childsym.symbol,tmppos+1,strlen(childsym.symbol))
					}
					else
					{
						tmpname = childsym.symbol
					}
					tmpname = cat(tmpname,"()")
					InsBufLine (hbuf, ln, tmpname )
					ln = ln + 1
				}
				ichild = ichild + 1
			}
			SymListFree(hsyml)

			// show buf
			SetCurrentBuf (hbuf)
		}
	}
}

