/*
这个模块是用来执行插入文本的，包括快速插入extern,include等关键字，并
把光标移动到合适的位置等待输入
*/

// Wrap ifdef <sz> .. endif around the current selection
macro IfdefSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef @sz@")
	InsBufLine(hbuf, lnLast+2, "#endif /* @sz@ */")
}
// 把参数字符串插入到当前窗口选定内容的两侧
// prefix : 插入到当前选定内容的前面
// subfix : 插入到当前选定内容的后面
// 如果当前窗口已经选择了部分文本,则把内容插入到这些文本所在的每一行的前面以及后面
// 如果当前窗口没有选择文本,则只把内容插入到当前位置
macro InsHeadNTail2Lines(prefix,suffix)
{
	var hwnd;
	var hbuf;
	var sel;
	var ln;
	var sz;
	var str;
	var len;

	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	// 如果当前已经选择内容，则要把prefix & subfix插入到
	// 这些内容的每一行
	if(sel.fExtended)
	{
		if ( sel.lnfirst != sel.lnlast)
		{
			ln = sel.lnFirst
			// 把prefix & subfix 插入每一行
			while(ln <= sel.lnLast)
			{
				str = GetBufLine (hbuf, ln)
				str = cat(prefix,str)
				str = cat(str,suffix)
				DelBufLine (hbuf, ln)
				InsBufLine (hbuf, ln, str)
				ln = ln + 1
			}
			// 选择所有操作过的行
			sel.ichFirst = 0;
			sz = getbufline(hbuf,sel.lnlast)
			sel.ichLim = strlen(sz)
			SetWndSel(hwnd,sel)
		}
		else
		{
			SetBufIns (hbuf, sel.lnfirst, sel.ichlim)
			SetBufSelText(hbuf,suffix)
			SetBufIns (hbuf, sel.lnfirst, sel.ichfirst)
			SetBufSelText(hbuf,prefix)
		}
	}
	else
	{
		// 如果没有选择文本,则只插入到当前位置
		str = cat(prefix,suffix)
		SetBufSelText(hbuf, str)
		len = strlen(suffix)
		while(len>0)
		{
			cursor_left
			len = len - 1
		}
	}
}

//insert string "#define "
macro Define()
{
	InsHeadNTail2Lines("#define ","")
}
//insert string "extern "
macro Extern()
{
	InsHeadNTail2Lines("extern ","")
}

macro InsGccAsm()
{
	InsHeadNTail2Lines("__asm__ (\"","\");")
}

//insert my name and the current data.
macro InsNameAndTime()
{
	hbuf = GetCurrentBuf()
	tmp = GetDate()
	tmp = Cat("Eden Zhong ",tmp)
	tmp = Cat(tmp,"    ")
	SetBufSelText(hbuf, tmp)
}


// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
	hbuf = GetCurrentBuf()
	SetBufSelText (hbuf, "Returns True if successful or False if errors.")
}

//insert string "void "
macro void()
{
	InsHeadNTail2Lines("void","")
}
//insert string "NULL == "
macro Null()
{
	InsHeadNTail2Lines("NULL","")
}
//insert string "#include "
macro Include()
{
	if ( "python" == GetCurFileType() )
	{
		InsHeadNTail2Lines("import ","")
	}
	else
	{
		InsHeadNTail2Lines("#include \"",".h\"")
	}
}
macro IncludeSys()
{
	if ( "python" == GetCurFileType() )
	{
		InsHeadNTail2Lines("import ","")
	}
	else
	{
		InsHeadNTail2Lines("#include <",">")
	}
}
macro InsTemplate()
{
	InsHeadNTail2Lines("template <typename T",">")
}
macro InsSpaceAfterCursor()
{
	hbuf = GetCurrentBuf()
	SetBufSelText(hbuf, " ")
	Cursor_Left
}
macro InsReturn()
{
	InsHeadNTail2Lines("return ",";")
}

macro InsCurlyReturn()
{
	InsHeadNTail2Lines("{return ",";}")
}

// Ask user for ifdef condition and wrap it around current
// selection.
macro InsertIfdef()
{
	sz = Ask("Enter ifdef condition:")
	if (sz != "")
		IfdefSz(sz);
}

macro InsertCPlusPlus()
{
	IfdefSz("__cplusplus");
}

macro InsToDo()
{
	InsHeadNTail2Lines("todo(\"","\")")
}
macro InsDefence()
{
	hbuf = GetCurrentBuf()
	SetBufSelText(hbuf, "// defence // ")
}

//insert multiline comment
macro InsMulCmt()
{
	var hwnd
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	var hbuf
	hbuf = GetWndBuf (hwnd)
	var sel
	sel = GetWndSel (hwnd)

	var str

	// get base indent
	var base_indent
	str = GetBufLine (hbuf, sel.lnfirst)
	base_indent = get_pre_space(str)

	var ln
	ln = sel.lnfirst+1
	var tmp
	var pos
	while(ln <= sel.lnlast )
	{
		str = GetBufLine (hbuf, ln)
		tmp = get_pre_space(str)
		pos = strcmp(base_indent,tmp)
		if ( pos > 0 )
		{
			base_indent = strmid(base_indent,0,pos-1)
		}
		else if ( pos < 0 )
		{
			base_indent = strmid(base_indent,0,0-1-pos)
		}
		ln = ln + 1
	}

	// plus
	var plus
	plus = IndentSign()
	plus = cat("*",plus)

	pos = strlen(base_indent)

	var new_line_content

	
	ln = sel.lnlast
	while(ln>= sel.lnfirst)
	{
		str = GetBufLine (hbuf, ln)
		tmp = strmid(str,0,pos)
		new_line_content = cat(tmp,plus)
		tmp = strmid(str,pos,strlen(str))
		new_line_content = cat(new_line_content,tmp)
		PutBufLine (hbuf, ln, new_line_content)

		ln = ln - 1
	}
	InsBufLine (hbuf, sel.lnlast+1, base_indent # "***********************************************************/")
	InsBufLine (hbuf, sel.lnfirst, base_indent # "/***********************************************************")
	Cursor_down
	end_of_line
}
