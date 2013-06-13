macro python_auto_curly_brace()
{
	hbuf = GetCurrentBuf ()

	// if the last char is not a ":", plus a ":"
	curln = GetBufLnCur (hbuf)
	cont = GetBufLine (hbuf, curln)
	cont = trim(cont)
	len = strlen(cont)
	if ( len > 0 )
	{
		last_ch = cont[len-1]
		if ( ":" != last_ch )
		{
			end_of_line
			SetBufSelText (hbuf,":")
		}
	}
	InsertLineAfterCur()
	end_of_line
	SetBufSelText(hbuf,IndentSign())
}
macro default_auto_curly_brace()
{
  var hwnd
  hwnd = GetCurrentWnd()
  if (hnil == hwnd)
  {
    return;
  }
  
  var hbuf
  hbuf = GetCurrentBuf()

  var sel
  sel = GetWndSel(hwnd)

  // get current line
  var szLine
  szLine = GetBufLine(hbuf, sel.lnFirst);

  // get indent
  var indent
  indent = get_pre_space(szLine)

  // prepare padding indent
  var plusIndent
  plusIndent = IndentSign();

  var ln
  if ( sel.fExtended )
  {
    ln = sel.lnLast
    while(ln>=sel.lnFirst)
    {
      InsBufLine(hbuf, ln + 1, "@indent@" # "{")
      InsBufLine(hbuf, ln + 2, "@indent@" # plusIndent );
      InsBufLine(hbuf, ln + 3, "@indent@" # "}")
      ln = ln - 1
    }
    setbufins(hbuf,ln+3,0)
    end_of_line
    return
  }
   
  // get last word
  MovCursorToSmartEnd()
  select_word
  sel = GetWndSel(hwnd)
  var word
  if ( sel.fextended )
  {
    word = strmid(szLine,sel.ichfirst,sel.ichlim)
    word = trim(word)
  }
  else
  {
    word = ""
  }
  end_of_line

  ln = sel.lnfirst
  if ( "if" == word 
    || "while" == word
    || "elseif" == word )
  {
    SetBufSelText(hbuf, " (###)")
    insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,false)
  }
  else if ("for"==word)
  {
    SetBufSelText(hbuf, " (###; ###; ###)")
    insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,false)
  }
  else if ("switch" == word)
  {
    SetBufSelText(hbuf, " (###)")
    InsBufLine(hbuf, ln + 1, "@indent@" # "{")
    InsBufLine(hbuf, ln + 2, "@indent@" # "case ###:")
    InsBufLine(hbuf, ln + 3, "@indent@" # plusIndent # "###")
    InsBufLine(hbuf, ln + 4, "@indent@" # plusIndent # "break;")
    InsBufLine(hbuf, ln + 5, "@indent@" # "}")
  }
  else if ("do"==word)
  {
    InsBufLine(hbuf, ln + 1, "@indent@" # "{")
    InsBufLine(hbuf, ln + 2, "@indent@" # plusIndent # "###");
    InsBufLine(hbuf, ln + 3, "@indent@" # "} while (###);")
  }
  else if ("case"==word)
  {
    SetBufSelText(hbuf, " ###:")
    InsBufLine(hbuf, ln + 1, "@indent@" # plusIndent # "###")
    InsBufLine(hbuf, ln + 2, "@indent@" # plusIndent # "break;")
  }
  else if ("typedef"== word) 
  {
    SetBufSelText(hbuf, " ###")
    insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,true)
  }
  else if ( ( "enum"==word)
    || ("struct"==word) )
  {
    insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,true)
    sel.lnFirst = ln+3;
    sel.lnLast = ln+3;
    sel.ichFirst = 0;
    sel.ichLim = 1
  }
  else if ("class"==word)
  {
    SetBufSelText(hbuf, " ###")
    InsBufLine(hbuf, ln + 1, "@indent@" # "{")
    InsBufLine(hbuf, ln + 2, "@indent@" # "public:")
    InsBufLine(hbuf, ln + 3, "@indent@" # plusIndent # "###");
    InsBufLine(hbuf, ln + 4, "@indent@" # "private:")
    InsBufLine(hbuf, ln + 5, "@indent@" # plusIndent # "###");
    InsBufLine(hbuf, ln + 6, "@indent@" # "};")
  }
  else if ( "try" ==word)
  {
    insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,false)
    InsBufLine(hbuf, ln + 4, "@indent@" # "catch ( ### )")
    insert_curly_in_coming_line(hbuf,ln+4,indent,plusIndent,false)
  }
  else if ("ts"==word)
  {
    PutBufLine(hbuf,ln,"@indent@typedef struct") 
    insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,true)
    sel.lnFirst = ln+3;
    sel.lnLast = ln+3;
    sel.ichFirst = 0;
    sel.ichLim = 1
  }
  else if ("te"==word)
  {
    PutBufLine(hbuf,ln,"@indent@typedef enum") 
    insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,true)
    sel.lnFirst = ln+3;
    sel.lnLast = ln+3;
    sel.ichFirst = 0;
    sel.ichLim = 1
  }
  else
  {
    InsBufLine(hbuf, ln + 1, "@indent@" # "{")
    InsBufLine(hbuf, ln + 2, "@indent@" # plusIndent # "");
    InsBufLine(hbuf, ln + 3, "@indent@" # "}")
    setbufins(hbuf,ln+2,0)
    end_of_line
    return
  }
  SetWndSel(hwnd, sel)
  LoadSearchPattern("###", true, false, false);
  Search_Forward
}

macro insert_curly_in_coming_line(hbuf,ln,indent,plusIndent,tail)
{
  InsBufLine(hbuf, ln + 1, "@indent@" # "{");
  InsBufLine(hbuf, ln + 2, "@indent@" # plusIndent# "###");
  if ( tail )
  {
    InsBufLine(hbuf, ln + 3, "@indent@" # "}###;");
  }
  else
  {
	  InsBufLine(hbuf, ln + 3, "@indent@" # "}");
  }
}

macro func_auto_curly_brace()
{
	if ( "python" == GetCurFileType() )
	{
		python_auto_curly_brace()
	}
	else
	{
		default_auto_curly_brace()
	}
}
