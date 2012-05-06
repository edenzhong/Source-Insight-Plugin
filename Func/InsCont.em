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
	InsHeadNTail2Lines("#include \"",".h\"")
}
macro IncludeSys()
{
	InsHeadNTail2Lines("#include <",">")
}
macro InsSpaceAfterCursor()
{
	hbuf = GetCurrentBuf()
	SetBufSelText(hbuf, " ")
	Cursor_Left
}
//insert string "return "
// 如果现在选择了文本,则在该文本前插入return 并在后面插入分号,并继续选中该文本
// 以便可以快速地把某个文本作为返回值
macro InsReturn()
{
	hwnd = GetCurrentWnd()
	if(hnil == hwnd)
	{
		msg("No active window!");
	}
	hbuf = GetWndBuf (hwnd)
	sel = GetWndSel (hwnd)

	if(sel.fExtended)
	{
		ln = sel.lnLast
		strcont = getbufline(hbuf,ln)
		strtmp = strmid(strcont,0,sel.ichLim)
		strtmp = cat(strtmp,";")

		tmp = strmid(strcont,sel.ichLim,strlen(strcont))
		strtmp = cat(strtmp,tmp)
		delbufline(hbuf,ln)
		insbufline(hbuf,ln,strtmp)
		
		ln = sel.lnFirst
		strcont = getbufline(hbuf,ln)
		strtmp = strmid(strcont,0,sel.ichFirst)
		strtmp = cat(strtmp,"return ")

		tmp = strmid(strcont,sel.ichFirst,strlen(strcont))
		strtmp = cat(strtmp,tmp)
		delbufline(hbuf,ln)
		insbufline(hbuf,ln,strtmp)

		sel.ichFirst = sel.ichFirst + strlen("return ")
		if(sel.lnLast == sel.LnFirst)
		{
			sel.ichLim = sel.ichLim + strlen("return ")
		}
		SetWndSel(hwnd,sel)
	}
	else
	{
		SetBufSelText(hbuf, "return ;")
		cursor_left
	}
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
	hbuf = GetCurrentBuf()
	SetBufSelText(hbuf, "/**********************************************************")
	Insert_Line_Before_Next
	SetBufSelText(hbuf, "*	")
	Insert_Line_Before_Next
	SetBufSelText(hbuf, "***********************************************************/")
	Cursor_Up
}

